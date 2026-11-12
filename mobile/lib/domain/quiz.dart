import 'dart:math';

import 'regras.dart';

class AlternativaQuiz {
  const AlternativaQuiz({required this.letra, this.texto, this.imagem, required this.correcta});

  /// Letra original (A–E, V/F). Na apresentação a letra mostrada é a da posição.
  final String letra;
  final String? texto;
  final String? imagem;
  final bool correcta;
}

class QuestaoQuiz {
  const QuestaoQuiz({
    required this.codigo,
    required this.tipo,
    required this.enunciado,
    required this.explicacao,
    required this.alternativas,
    this.imagens = const [],
    this.dica,
    this.tema,
    this.temaNome,
    this.textoBase,
    this.textoBaseTitulo,
    this.ano,
    this.nivel,
  });

  final String codigo;
  final String tipo;
  final String enunciado;
  final String explicacao;
  final List<AlternativaQuiz> alternativas;
  final List<String> imagens;
  final String? dica;
  final String? tema;
  final String? temaNome;
  final String? textoBase;
  final String? textoBaseTitulo;
  final int? ano;
  final int? nivel;

  bool get verdadeiroFalso => tipo == 'verdadeiro_falso';
}

/// Estado de uma questão durante a tentativa.
class RespostaQuiz {
  RespostaQuiz(this.questao, this.ordem);

  final QuestaoQuiz questao;

  /// Alternativas pela ordem apresentada (baralhada)
  final List<AlternativaQuiz> ordem;

  /// Índice escolhido em [ordem]
  int? escolhida;
  bool confirmada = false;
  bool usouDica = false;
  bool viuResposta = false;
  bool marcada = false;
  int tempoSeg = 0;

  AlternativaQuiz? get alternativaEscolhida => escolhida == null ? null : ordem[escolhida!];
  int get indiceCorrecto => ordem.indexWhere((a) => a.correcta);
  bool get certa => alternativaEscolhida?.correcta ?? false;

  /// Conta para a nota: certa e sem ter visto a resposta.
  bool get contaComoCerta => certa && !viuResposta;
}

enum ModoQuiz { praticar, simulado }

/// Motor do quiz: questões e alternativas baralhadas, dica, ver resposta, marcar e nota.
class SessaoQuiz {
  SessaoQuiz({required List<QuestaoQuiz> questoes, required this.modo, Random? random, this.baralharQuestoes = true})
      : random = random ?? Random() {
    final lista = [...questoes];
    if (baralharQuestoes) lista.shuffle(this.random);
    respostas = [for (final q in lista) RespostaQuiz(q, _baralhar(q))];
  }

  final ModoQuiz modo;
  final Random random;
  final bool baralharQuestoes;
  late final List<RespostaQuiz> respostas;
  final DateTime iniciadaEm = DateTime.now();
  int actual = 0;

  List<AlternativaQuiz> _baralhar(QuestaoQuiz q) {
    // V/F mantém a ordem Verdadeiro, Falso
    if (q.verdadeiroFalso) return [...q.alternativas];
    return [...q.alternativas]..shuffle(random);
  }

  bool get simulado => modo == ModoQuiz.simulado;
  int get total => respostas.length;
  RespostaQuiz get questaoActual => respostas[actual];
  bool get ultima => actual == total - 1;

  void escolher(int indice) {
    final r = questaoActual;
    if (r.confirmada && !simulado) return;
    r.escolhida = indice;
  }

  /// Praticar: confirma a resposta e mostra o feedback.
  void confirmar() {
    if (questaoActual.escolhida == null) return;
    questaoActual.confirmada = true;
  }

  /// A dica não penaliza. Não existe nos simulados.
  void usarDica() {
    if (simulado || questaoActual.questao.dica == null) return;
    questaoActual.usouDica = true;
  }

  /// Ver resposta: revela a correcta; a questão deixa de contar como certa.
  void verResposta() {
    if (simulado) return;
    final r = questaoActual;
    r.viuResposta = true;
    r.escolhida ??= r.indiceCorrecto;
    r.confirmada = true;
  }

  void alternarMarca() {
    if (simulado) questaoActual.marcada = !questaoActual.marcada;
  }

  void irPara(int i) {
    if (i >= 0 && i < total) actual = i;
  }

  bool seguinte() {
    if (ultima) return false;
    actual++;
    return true;
  }

  int get respondidas => respostas.where((r) => r.escolhida != null).length;
  int get certas => respostas.where((r) => r.contaComoCerta).length;
  int get comAjuda => respostas.where((r) => r.viuResposta).length;
  int get erradas => respostas.where((r) => r.escolhida != null && !r.certa).length;

  double get percentagem => Regras.percentagem(total: total, certasSemVerResposta: certas);
}
