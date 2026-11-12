import 'dart:convert';
import 'dart:io';

import 'package:aprova_mais/data/api.dart';
import 'package:aprova_mais/data/importador.dart';
import 'package:aprova_mais/data/repositorios.dart';
import 'package:aprova_mais/data/sincronizacao.dart';
import 'package:aprova_mais/domain/quiz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'ajuda.dart';

void main() {
  test('importa o conteúdo grátis (catálogo, preços, níveis, questões) e não repete a mesma versão', () async {
    final db = contentEmMemoria();
    final imp = ImportadorConteudo(db);
    expect(await imp.importarConteudoApp(conteudoApp()), isTrue);
    expect(await imp.importarConteudoApp(conteudoApp()), isFalse, reason: 'mesma versão');
    expect(await imp.importarConteudoApp(conteudoApp(versao: 2)), isTrue);

    final repo = ConteudoRepo(db);
    expect(await repo.questoesPorNivel('TST-MAT'), {1: 2, 2: 2});
    final qs = await repo.questoes('TST-MAT', nivel: 1);
    expect(qs.map((q) => q.codigo).toSet(), {'TST-MAT-2025-001', 'TST-MAT-2025-002'});
    final vf = qs.firstWhere((q) => q.verdadeiroFalso);
    expect(vf.alternativas.where((a) => a.correcta).single.letra, 'V');
    final ofertas = await repo.ofertas(pesquisa: 'informatica');
    expect(ofertas.single.provas.single.codigo, 'TST-MAT');
    expect((await repo.produtos(prova: 'TST-MAT')).map((x) => x.row.precoMt), [59, 49]);
    expect((await repo.regras()).niveisGratis, 2);
    await db.close();
  });

  test('o conteúdo embutido real (assets/content/conteudo.json) importa sem erros', () async {
    final f = File('assets/content/conteudo.json');
    expect(f.existsSync(), isTrue, reason: 'gerar com: cd backend; npm run exportar:app');
    final db = contentEmMemoria();
    await ImportadorConteudo(db).importarConteudoApp(jsonDecode(await f.readAsString()) as Map<String, dynamic>);
    final repo = ConteudoRepo(db);
    final ofertas = await repo.ofertas();
    expect(ofertas.length, greaterThan(100));
    final comQuestoes = await repo.provasComQuestoes();
    expect(comQuestoes, contains('UEM-MAT2'));
    // Todos os cursos que vêm na app têm pelo menos um nível aberto
    final semNivel = [for (final o in ofertas) if (!o.provas.any((p) => comQuestoes.contains(p.codigo))) o.codigo];
    expect(semNivel, isEmpty);
    // Provas partilhadas avisam de onde vêm as perguntas
    final upBio = await repo.prova('UP-BIO');
    expect(upBio!.partilhada, isTrue);
    expect(upBio.avisoPartilha, contains('UEM'));
    // O nível 1 de cada prova tem 20 questões
    for (final prova in comQuestoes) {
      expect((await repo.questoesPorNivel(prova))[1], 20, reason: prova);
    }
    // Só níveis grátis no APK
    for (final prova in comQuestoes) {
      expect((await repo.questoesPorNivel(prova)).keys.every((n) => n <= 2), isTrue, reason: prova);
    }
    // Todas as imagens referidas estão nos assets
    for (final prova in comQuestoes) {
      for (final QuestaoQuiz q in await repo.questoes(prova)) {
        for (final i in [...q.imagens, ...q.alternativas.map((a) => a.imagem).whereType<String>()]) {
          expect(File('assets/content/imagens/$i').existsSync(), isTrue, reason: i);
        }
      }
    }
    await db.close();
  });

  group('pacote pago', () {
    late Directory tmp;
    setUp(() => tmp = Directory.systemTemp.createTempSync('aprova-test-'));
    tearDown(() => tmp.deleteSync(recursive: true));

    Sincronizador sync(content, user) => Sincronizador(api: ApiCliente(baseUrl: 'http://x'), content: content, user: user, pasta: tmp);

    test('checksum certo: importa os níveis pagos e as imagens numa transacção', () async {
      final content = contentEmMemoria();
      final user = userEmMemoria();
      await ImportadorConteudo(content).importarConteudoApp(conteudoApp());
      final zip = zipPacote();
      final f = File(p.join(tmp.path, 'p.zip'))..writeAsBytesSync(zip);

      final n = await sync(content, user).instalarFicheiro(f, prova: 'TST-MAT', sha256: sha256De(zip));
      expect(n, 3);
      expect(await ConteudoRepo(content).questoesPorNivel('TST-MAT'), {1: 2, 2: 2, 3: 2, 4: 1});
      expect(await ConteudoRepo(content).pacoteInstalado('TST-MAT'), 1);
      expect(File(p.join(tmp.path, 'imagens', 'TST-MAT-2025-010.png')).existsSync(), isTrue);
      expect(f.existsSync(), isFalse, reason: 'o zip é apagado depois de importar');
    });

    test('checksum errado: recusa, apaga o ficheiro e não toca na content.db nem na user.db', () async {
      final content = contentEmMemoria();
      final user = userEmMemoria();
      await ImportadorConteudo(content).importarConteudoApp(conteudoApp());
      final repoUser = UtilizadorRepo(user);
      await repoUser.gravarPerfil(nome: 'Ana', avatar: '🦁');
      final antes = await ConteudoRepo(content).questoesPorNivel('TST-MAT');

      final zip = zipPacote();
      final f = File(p.join(tmp.path, 'p.zip'))..writeAsBytesSync(zip);
      await expectLater(sync(content, user).instalarFicheiro(f, prova: 'TST-MAT', sha256: 'f' * 64), throwsA(isA<ChecksumInvalido>()));
      expect(f.existsSync(), isFalse);
      expect(await ConteudoRepo(content).questoesPorNivel('TST-MAT'), antes);
      expect(await ConteudoRepo(content).pacoteInstalado('TST-MAT'), isNull);
      expect((await repoUser.perfil())!.nome, 'Ana');
    });

    test('pacote de outra prova é recusado', () async {
      final content = contentEmMemoria();
      await ImportadorConteudo(content).importarConteudoApp(conteudoApp());
      final zip = zipPacote(prova: 'OUTRA');
      final f = File(p.join(tmp.path, 'p.zip'))..writeAsBytesSync(zip);
      await expectLater(sync(content, userEmMemoria()).instalarFicheiro(f, prova: 'TST-MAT', sha256: sha256De(zip)), throwsA(isA<ConteudoInvalido>()));
      expect(await ConteudoRepo(content).questoesPorNivel('TST-MAT'), {1: 2, 2: 2});
    });
  });
}
