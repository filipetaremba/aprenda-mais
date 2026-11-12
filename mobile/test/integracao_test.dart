import 'dart:io';

import 'package:aprova_mais/data/activacao.dart';
import 'package:aprova_mais/data/api.dart';
import 'package:aprova_mais/data/importador.dart';
import 'package:aprova_mais/data/licencas.dart';
import 'package:aprova_mais/data/repositorios.dart';
import 'package:aprova_mais/data/sincronizacao.dart';
import 'package:aprova_mais/domain/quiz.dart';
import 'package:aprova_mais/domain/regras.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'ajuda.dart';

/// Teste de integração: activar código → pacote importado → nível 3 abre.
void main() {
  late Directory tmp;
  setUp(() => tmp = Directory.systemTemp.createTempSync('aprova-int-'));
  tearDown(() => tmp.deleteSync(recursive: true));

  Future<void> passarNivel(ConteudoRepo conteudo, UtilizadorRepo user, int nivel) async {
    final s = SessaoQuiz(questoes: await conteudo.questoes('TST-MAT', nivel: nivel), modo: ModoQuiz.praticar);
    for (final r in s.respostas) {
      s.escolher(r.indiceCorrecto);
      s.confirmar();
      s.seguinte();
    }
    await user.gravarTentativa(s, prova: 'TST-MAT', nivel: nivel, notaMinima: 70);
  }

  test('activar código → licença verificada → pacote descarregado e importado → nível 3 abre', () async {
    final chaves = await ChavesTeste.gerar();
    final servidor = ServidorFalso(chaves);
    final content = contentEmMemoria();
    final userDb = userEmMemoria();
    final api = ApiCliente(baseUrl: 'http://servidor', cliente: servidor.cliente);
    final conteudo = ConteudoRepo(content);
    final user = UtilizadorRepo(userDb);
    final licencas = LicencasRepo(userDb, VerificadorLicencas(chaves.publicaBase64));
    final activacao = ServicoActivacao(api: api, user: user, licencas: licencas);
    final sync = Sincronizador(api: api, content: content, user: userDb, pasta: tmp);

    Future<EstadoNivel> estadoNivel3() async =>
        (await detalheDaProva(conteudo, user, await licencas.validas(), 'TST-MAT'))!.niveis[2].estado;

    await ImportadorConteudo(content).importarConteudoApp(conteudoApp());
    await passarNivel(conteudo, user, 1);
    await passarNivel(conteudo, user, 2);
    expect(await estadoNivel3(), EstadoNivel.pago, reason: 'sem licença → paywall');

    // Código errado e sem Internet: erros claros, nada muda
    await expectLater(activacao.activar(codigo: 'APV-2222-2222'), throwsA(isA<ErroApi>().having((e) => e.codigo, 'codigo', 'CODIGO_INVALIDO')));
    servidor.semInternet = true;
    Object? semRede;
    try {
      await activacao.activar(codigo: 'APV-7K9Q-M2XZ');
    } catch (e) {
      semRede = e;
    }
    expect(semRede, isA<SemInternet>());
    expect(ServicoActivacao.mensagemDe(semRede!), contains('Sem Internet'));
    servidor.semInternet = false;

    // Activar
    final r = await activacao.activar(codigo: 'APV-7K9Q-M2XZ', telefone: '841234567', nome: 'Ana');
    expect(r.licencas.single.produto, 'TST-MAT-NIVEIS');
    expect(await user.token(), 'apv_tokendeteste_tokendeteste');
    expect(await estadoNivel3(), EstadoNivel.porDescarregar, reason: 'licença válida mas falta o pacote');

    // Sincronizar (com progresso)
    final fases = <FaseSync>[];
    final instalados = await sync.sincronizar(r.pacotes, token: (await user.token())!, progresso: (x) => fases.add(x.fase));
    expect(instalados, 1);
    expect(fases, containsAllInOrder([FaseSync.descarregar, FaseSync.verificar, FaseSync.importar, FaseSync.concluido]));
    expect(await sync.pendentes(), isEmpty);
    expect(await estadoNivel3(), EstadoNivel.disponivel);
    expect((await conteudo.questoes('TST-MAT', nivel: 3)).length, 2);

    // Código usado não volta a activar; sincronizar outra vez não descarrega nada
    await expectLater(activacao.activar(codigo: 'APV-7K9Q-M2XZ'), throwsA(isA<ErroApi>().having((e) => e.codigo, 'codigo', 'CODIGO_USADO')));
    final antes = servidor.pedidos.length;
    expect(await sync.sincronizar(r.pacotes, token: 'apv_tokendeteste_tokendeteste'), 0);
    expect(servidor.pedidos.length, antes);
  });

  test('download interrompido: retoma a partir do que já tinha (Range)', () async {
    final chaves = await ChavesTeste.gerar();
    final servidor = ServidorFalso(chaves);
    final content = contentEmMemoria();
    final userDb = userEmMemoria();
    final api = ApiCliente(baseUrl: 'http://servidor', cliente: servidor.cliente);
    await ImportadorConteudo(content).importarConteudoApp(conteudoApp());
    final sync = Sincronizador(api: api, content: content, user: userDb, pasta: tmp);
    final pacote = PacoteRemoto(
      prova: 'TST-MAT',
      versao: 1,
      sha256: sha256De(servidor.zip),
      tamanhoBytes: servidor.zip.length,
      url: '/api/v1/pacotes/TST-MAT/download',
    );

    // Primeira tentativa: sem Internet → fica pendente
    servidor.semInternet = true;
    await expectLater(sync.sincronizar([pacote], token: 't'), throwsA(isA<SemInternet>()));
    expect((await sync.pendentes()).single.prova, 'TST-MAT');

    // Simula metade do ficheiro já descarregada antes de a ligação cair
    final parte = File(p.join(tmp.path, 'downloads', 'TST-MAT-v1.part'))..createSync(recursive: true);
    parte.writeAsBytesSync(servidor.zip.sublist(0, servidor.zip.length ~/ 2));

    servidor.semInternet = false;
    expect(await sync.retomar(token: 't'), 1);
    final download = servidor.pedidos.lastWhere((x) => x.url.path.endsWith('/download'));
    expect(download.headers['Range'], 'bytes=${servidor.zip.length ~/ 2}-');
    expect(download.url.queryParameters['versao'], '1');
    expect(await ConteudoRepo(content).pacoteInstalado('TST-MAT'), 1);
    expect(await sync.pendentes(), isEmpty);
  });
}
