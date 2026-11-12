import 'dart:math';

import 'package:aprova_mais/domain/quiz.dart';
import 'package:aprova_mais/domain/regras.dart';
import 'package:flutter_test/flutter_test.dart';

List<DadosNivel> niveis(Map<int, double> melhor, {int questoes = 4, Map<int, int> notaMinima = const {}}) => [
      for (var n = 1; n <= 10; n++) DadosNivel(numero: n, numQuestoes: questoes, notaMinima: notaMinima[n], melhorPercentagem: melhor[n]),
    ];

QuestaoQuiz q(String codigo, {String? dica, String tipo = 'escolha_multipla'}) => QuestaoQuiz(
      codigo: codigo,
      tipo: tipo,
      enunciado: 'x',
      explicacao: 'y',
      dica: dica,
      alternativas: tipo == 'verdadeiro_falso'
          ? const [AlternativaQuiz(letra: 'V', texto: 'Verdadeiro', correcta: true), AlternativaQuiz(letra: 'F', texto: 'Falso', correcta: false)]
          : [for (final l in ['A', 'B', 'C', 'D']) AlternativaQuiz(letra: l, texto: l, correcta: l == 'C')],
    );

void main() {
  const regras = Regras();

  group('desbloqueio de níveis', () {
    test('no início só o nível 1 está disponível', () {
      final e = regras.estados(niveis({}), temLicenca: false, pacoteInstalado: false);
      expect(e[0], EstadoNivel.disponivel);
      expect(e.skip(1).every((x) => x == EstadoNivel.bloqueado), isTrue);
    });

    test('o nível N+1 abre com nota ≥ 70% no nível N (69,9% não chega)', () {
      expect(regras.estados(niveis({1: 69.9}), temLicenca: false, pacoteInstalado: false).take(2), [EstadoNivel.disponivel, EstadoNivel.bloqueado]);
      expect(regras.estados(niveis({1: 70}), temLicenca: false, pacoteInstalado: false).take(2), [EstadoNivel.concluido, EstadoNivel.disponivel]);
    });

    test('a nota mínima é configurável por nível', () {
      final e = regras.estados(niveis({1: 75}, notaMinima: {1: 80}), temLicenca: false, pacoteInstalado: false);
      expect(e[1], EstadoNivel.bloqueado);
      final e2 = const Regras(notaMinimaPadrao: 50).estados(niveis({1: 55}), temLicenca: false, pacoteInstalado: false);
      expect(e2[1], EstadoNivel.disponivel);
    });

    test('níveis 1–2 grátis; o 3 exige licença E pacote', () {
      final passou12 = niveis({1: 100, 2: 90});
      expect(regras.estados(passou12, temLicenca: false, pacoteInstalado: false)[2], EstadoNivel.pago);
      expect(regras.estados(passou12, temLicenca: true, pacoteInstalado: false)[2], EstadoNivel.porDescarregar);
      expect(regras.estados(passou12, temLicenca: true, pacoteInstalado: true)[2], EstadoNivel.disponivel);
      // sem licença o 4 continua bloqueado pelo progresso
      expect(regras.estados(passou12, temLicenca: false, pacoteInstalado: false)[3], EstadoNivel.bloqueado);
    });

    test('nível sem questões', () {
      expect(regras.estados(niveis({}, questoes: 0), temLicenca: false, pacoteInstalado: false)[0], EstadoNivel.semQuestoes);
    });
  });

  group('nota e quiz', () {
    test('percentagem = certas sem ver resposta / total × 100', () {
      expect(Regras.percentagem(total: 20, certasSemVerResposta: 16), 80);
      expect(Regras.percentagem(total: 0, certasSemVerResposta: 0), 0);
    });

    test('dica não penaliza; ver resposta não conta como certa', () {
      final s = SessaoQuiz(questoes: [q('1', dica: 'pensa'), q('2'), q('3'), q('4')], modo: ModoQuiz.praticar, random: Random(1), baralharQuestoes: false);
      // 1: usa dica e acerta
      s.usarDica();
      s.escolher(s.questaoActual.indiceCorrecto);
      s.confirmar();
      s.seguinte();
      // 2: vê a resposta
      s.verResposta();
      expect(s.questaoActual.certa, isTrue);
      expect(s.questaoActual.contaComoCerta, isFalse);
      s.seguinte();
      // 3: erra
      s.escolher((s.questaoActual.indiceCorrecto + 1) % 4);
      s.confirmar();
      s.seguinte();
      // 4: acerta
      s.escolher(s.questaoActual.indiceCorrecto);
      s.confirmar();

      expect(s.certas, 2);
      expect(s.comAjuda, 1);
      expect(s.erradas, 1);
      expect(s.percentagem, 50);
      expect(s.respostas.first.usouDica, isTrue);
    });

    test('alternativas baralhadas mantêm a correcta; V/F fica pela ordem Verdadeiro, Falso', () {
      final ordens = <String>{};
      for (var seed = 0; seed < 20; seed++) {
        final s = SessaoQuiz(questoes: [q('1'), q('vf', tipo: 'verdadeiro_falso')], modo: ModoQuiz.praticar, random: Random(seed), baralharQuestoes: false);
        final em = s.respostas[0];
        expect(em.ordem[em.indiceCorrecto].letra, 'C');
        ordens.add(em.ordem.map((a) => a.letra).join());
        expect(s.respostas[1].ordem.map((a) => a.letra), ['V', 'F']);
      }
      expect(ordens.length, greaterThan(1), reason: 'a ordem tem de variar');
    });

    test('simulado: sem dica nem ver resposta; marcar e navegar livremente', () {
      final s = SessaoQuiz(questoes: [q('1', dica: 'x'), q('2')], modo: ModoQuiz.simulado, baralharQuestoes: false);
      s.usarDica();
      s.verResposta();
      expect(s.questaoActual.usouDica, isFalse);
      expect(s.questaoActual.viuResposta, isFalse);
      s.alternarMarca();
      expect(s.questaoActual.marcada, isTrue);
      s.irPara(1);
      s.escolher(0);
      s.escolher(s.questaoActual.indiceCorrecto); // pode mudar a resposta
      expect(s.respondidas, 1);
      expect(s.percentagem, 50);
    });
  });
}
