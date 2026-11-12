import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:path/path.dart' as p;

import 'api.dart';
import 'content/content_db.dart';
import 'importador.dart';
import 'user/user_db.dart';

/// O ficheiro descarregado não corresponde ao checksum anunciado pelo servidor.
class ChecksumInvalido implements Exception {
  ChecksumInvalido(this.prova);
  final String prova;
  @override
  String toString() => 'O pacote de $prova chegou danificado.';
}

enum FaseSync { descarregar, verificar, importar, concluido }

class ProgressoSync {
  const ProgressoSync({
    required this.prova,
    required this.indice,
    required this.total,
    required this.fase,
    this.bytes = 0,
    this.bytesTotal = 0,
  });

  final String prova;

  /// Pacote actual (1..total)
  final int indice;
  final int total;
  final FaseSync fase;
  final int bytes;
  final int bytesTotal;

  double get fraccao => bytesTotal == 0 ? 0 : (bytes / bytesTotal).clamp(0, 1);
}

/// Descarrega e importa os pacotes pagos das provas licenciadas.
///
/// - A lista de pacotes por instalar fica guardada (user.db) até terminar: se falhar a meio
///   (sem Internet, app fechada), [retomar] continua de onde parou (Range no download).
/// - Cada pacote: download → SHA-256 → unzip → importação numa transacção na content.db.
///   A user.db (progresso do estudante) nunca é tocada.
class Sincronizador {
  Sincronizador({required this.api, required this.content, required this.user, required this.pasta});

  final ApiCliente api;
  final ContentDb content;
  final UserDb user;

  /// Pasta da app para conteúdo descarregado (imagens/ e downloads/)
  final Directory pasta;

  static const _chavePendentes = 'pacotes_pendentes';

  Directory get pastaImagens => Directory(p.join(pasta.path, 'imagens'));
  Directory get _pastaDownloads => Directory(p.join(pasta.path, 'downloads'));

  /// Só os que ainda não estão instalados nesta versão (ou superior).
  Future<List<PacoteRemoto>> porInstalar(List<PacoteRemoto> pacotes) async {
    final instalados = {for (final r in await content.select(content.pacotesInstalados).get()) r.prova: r.versao};
    return [for (final x in pacotes) if ((instalados[x.prova] ?? 0) < x.versao) x];
  }

  Future<List<PacoteRemoto>> pendentes() async {
    final j = await user.pref(_chavePendentes);
    if (j == null) return [];
    return [for (final x in jsonDecode(j) as List) PacoteRemoto.deJson(x as Map<String, dynamic>)];
  }

  Future<void> _gravarPendentes(List<PacoteRemoto> l) =>
      l.isEmpty ? user.apagarPref(_chavePendentes) : user.definirPref(_chavePendentes, jsonEncode([for (final x in l) x.toJson()]));

  /// Instala os [pacotes] (os que faltam). Devolve o nº de pacotes instalados.
  Future<int> sincronizar(List<PacoteRemoto> pacotes, {required String token, void Function(ProgressoSync)? progresso}) async {
    final faltam = await porInstalar(pacotes);
    await _gravarPendentes(faltam);
    var feitos = 0;
    for (final (i, pac) in faltam.indexed) {
      void avisar(FaseSync f, [int b = 0]) =>
          progresso?.call(ProgressoSync(prova: pac.prova, indice: i + 1, total: faltam.length, fase: f, bytes: b, bytesTotal: pac.tamanhoBytes));

      await _pastaDownloads.create(recursive: true);
      final parte = File(p.join(_pastaDownloads.path, '${pac.prova}-v${pac.versao}.part'));
      avisar(FaseSync.descarregar, await parte.exists() ? await parte.length() : 0);
      if (!await parte.exists() || await parte.length() < pac.tamanhoBytes) {
        await api.descarregar(pac, token: token, destino: parte, progresso: (b, _) => avisar(FaseSync.descarregar, b));
      }
      avisar(FaseSync.verificar, pac.tamanhoBytes);
      await instalarFicheiro(parte, prova: pac.prova, sha256: pac.sha256);
      feitos++;
      await _gravarPendentes(faltam.sublist(i + 1));
      avisar(FaseSync.importar, pac.tamanhoBytes);
    }
    progresso?.call(ProgressoSync(prova: '', indice: faltam.length, total: faltam.length, fase: FaseSync.concluido));
    return feitos;
  }

  /// Continua uma sincronização que ficou a meio.
  Future<int> retomar({required String token, void Function(ProgressoSync)? progresso}) async =>
      sincronizar(await pendentes(), token: token, progresso: progresso);

  /// Verifica o checksum de um .zip descarregado e importa-o. Com checksum errado o ficheiro é
  /// apagado (para voltar a ser descarregado) e a base fica como estava.
  Future<int> instalarFicheiro(File ficheiro, {required String prova, required String sha256}) async {
    final bytes = await ficheiro.readAsBytes();
    final calculado = crypto.sha256.convert(bytes).toString();
    if (calculado != sha256) {
      await ficheiro.delete();
      throw ChecksumInvalido(prova);
    }
    final zip = ZipDecoder().decodeBytes(bytes);
    Map<String, dynamic>? pacote;
    final imagens = <String, List<int>>{};
    for (final f in zip.files) {
      if (!f.isFile) continue;
      if (f.name == 'pacote.json') {
        pacote = jsonDecode(utf8.decode(f.content)) as Map<String, dynamic>;
      } else if (f.name.startsWith('imagens/')) {
        // só o nome (evita caminhos fora da pasta)
        imagens[p.basename(f.name)] = f.content;
      }
    }
    if (pacote == null) throw ConteudoInvalido('pacote.json em falta');

    await pastaImagens.create(recursive: true);
    for (final MapEntry(:key, :value) in imagens.entries) {
      await File(p.join(pastaImagens.path, key)).writeAsBytes(value, flush: true);
    }
    final n = await ImportadorConteudo(content).importarPacote(pacote, provaEsperada: prova, sha256: sha256);
    await ficheiro.delete();
    return n;
  }

  Future<int?> versaoInstalada(String prova) async =>
      (await (content.select(content.pacotesInstalados)..where((t) => t.prova.equals(prova))).getSingleOrNull())?.versao;
}

