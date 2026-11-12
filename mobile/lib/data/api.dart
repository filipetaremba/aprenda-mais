import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Erro devolvido pelo servidor: { erro: { codigo, mensagem } }.
class ErroApi implements Exception {
  ErroApi(this.codigo, this.mensagem, [this.status]);
  final String codigo;
  final String mensagem;
  final int? status;
  @override
  String toString() => 'ErroApi($codigo): $mensagem';
}

/// Sem ligação ao servidor (sem Internet, servidor desligado, tempo esgotado).
class SemInternet implements Exception {
  @override
  String toString() => 'Sem ligação à Internet.';
}

class PacoteRemoto {
  const PacoteRemoto({required this.prova, required this.versao, required this.sha256, required this.tamanhoBytes, required this.url});

  factory PacoteRemoto.deJson(Map<String, dynamic> j) => PacoteRemoto(
        prova: j['prova'] as String,
        versao: j['versao'] as int,
        sha256: j['sha256'] as String,
        tamanhoBytes: j['tamanho_bytes'] as int,
        url: j['url'] as String,
      );

  final String prova;
  final int versao;
  final String sha256;
  final int tamanhoBytes;
  final String url;

  Map<String, dynamic> toJson() => {'prova': prova, 'versao': versao, 'sha256': sha256, 'tamanho_bytes': tamanhoBytes, 'url': url};
}

class RespostaActivacao {
  RespostaActivacao(this.json);
  final Map<String, dynamic> json;

  String get token => json['token'] as String;
  bool get restaurado => json['restaurado'] == true;
  Map<String, dynamic> get estudante => json['estudante'] as Map<String, dynamic>;
  List<Map<String, dynamic>> get licencas => [for (final l in json['licencas'] as List) l as Map<String, dynamic>];
  List<PacoteRemoto> get pacotes => [for (final p in json['pacotes'] as List) PacoteRemoto.deJson(p as Map<String, dynamic>)];
}

/// Cliente da API /api/v1. A app só precisa de Internet para activar, restaurar e actualizar.
class ApiCliente {
  ApiCliente({required this.baseUrl, http.Client? cliente, this.timeout = const Duration(seconds: 20)})
      : _http = cliente ?? http.Client();

  final String baseUrl;
  final http.Client _http;
  final Duration timeout;

  Uri uri(String caminho) => Uri.parse('$baseUrl${caminho.startsWith('/api/') ? caminho : '/api/v1$caminho'}');

  Future<Map<String, dynamic>> _json(Future<http.Response> Function() pedido) async {
    final http.Response r;
    try {
      r = await pedido().timeout(timeout);
    } on SocketException {
      throw SemInternet();
    } on http.ClientException {
      throw SemInternet();
    } on TimeoutException {
      throw SemInternet();
    } on HandshakeException {
      throw SemInternet();
    }
    Map<String, dynamic> corpo;
    try {
      corpo = jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>;
    } catch (_) {
      throw ErroApi('RESPOSTA_INVALIDA', 'O servidor respondeu de forma inesperada.', r.statusCode);
    }
    if (r.statusCode >= 400) {
      final e = corpo['erro'] as Map<String, dynamic>? ?? const {};
      throw ErroApi(e['codigo'] as String? ?? 'ERRO', e['mensagem'] as String? ?? 'Erro ${r.statusCode}', r.statusCode);
    }
    return corpo;
  }

  Map<String, String> _cabecalhos(String? token) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Future<RespostaActivacao> activar({
    required String codigo,
    required String dispositivoId,
    String? telefone,
    String? nome,
    String? token,
  }) async {
    final corpo = jsonEncode({
      'codigo': codigo,
      'dispositivoId': dispositivoId,
      if (telefone != null && telefone.isNotEmpty) 'telefone': telefone,
      if (nome != null && nome.isNotEmpty) 'nome': nome,
    });
    return RespostaActivacao(await _json(() => _http.post(uri('/activacao'), headers: _cabecalhos(token), body: corpo)));
  }

  Future<({List<Map<String, dynamic>> licencas, List<PacoteRemoto> pacotes})> licencas(String token) async {
    final j = await _json(() => _http.get(uri('/licencas'), headers: _cabecalhos(token)));
    return (
      licencas: [for (final l in j['licencas'] as List) l as Map<String, dynamic>],
      pacotes: [for (final p in j['pacotes'] as List) PacoteRemoto.deJson(p as Map<String, dynamic>)],
    );
  }

  Future<Map<String, dynamic>> catalogo() => _json(() => _http.get(uri('/catalogo'), headers: _cabecalhos(null)));

  /// Descarrega para [destino] (ficheiro .part), retomando a partir do que já lá está (Range).
  /// [progresso] recebe (bytes recebidos, total).
  Future<void> descarregar(
    PacoteRemoto p, {
    required String token,
    required File destino,
    void Function(int recebidos, int total)? progresso,
  }) async {
    final jaTem = await destino.exists() ? await destino.length() : 0;
    final pedido = http.Request('GET', Uri.parse('${uri(p.url)}?versao=${p.versao}'))
      ..headers.addAll({
        'Authorization': 'Bearer $token',
        if (jaTem > 0 && jaTem < p.tamanhoBytes) 'Range': 'bytes=$jaTem-',
      });
    final http.StreamedResponse r;
    try {
      r = await _http.send(pedido).timeout(timeout);
    } on SocketException {
      throw SemInternet();
    } on http.ClientException {
      throw SemInternet();
    } on TimeoutException {
      throw SemInternet();
    }
    if (r.statusCode >= 400) {
      final texto = await r.stream.bytesToString();
      Map<String, dynamic>? e;
      try {
        e = (jsonDecode(texto) as Map<String, dynamic>)['erro'] as Map<String, dynamic>?;
      } catch (_) {}
      throw ErroApi(e?['codigo'] as String? ?? 'ERRO', e?['mensagem'] as String? ?? 'Erro ${r.statusCode} ao descarregar.', r.statusCode);
    }
    // 206 = continua o ficheiro; 200 = começa do zero
    final continuar = r.statusCode == 206 && jaTem > 0;
    final saida = destino.openWrite(mode: continuar ? FileMode.append : FileMode.write);
    var recebidos = continuar ? jaTem : 0;
    try {
      await for (final bloco in r.stream.timeout(timeout)) {
        saida.add(bloco);
        recebidos += bloco.length;
        progresso?.call(recebidos, p.tamanhoBytes);
      }
    } on TimeoutException {
      throw SemInternet();
    } on SocketException {
      throw SemInternet();
    } on http.ClientException {
      throw SemInternet();
    } finally {
      await saida.close();
    }
  }
}
