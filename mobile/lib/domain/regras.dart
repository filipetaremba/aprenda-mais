/// Regras de negócio puras (sem base de dados nem Flutter), para serem fáceis de testar.
library;

const numNiveis = 10;
const notaMinimaPadraoOmissao = 70;
const niveisGratisOmissao = 2;

enum EstadoNivel {
  /// Passou com nota ≥ mínima (pode repetir)
  concluido,

  /// Pode jogar agora
  disponivel,

  /// Falta passar o nível anterior
  bloqueado,

  /// Nível pago sem licença válida → paywall
  pago,

  /// Tem licença mas o pacote ainda não foi descarregado
  porDescarregar,

  /// Ainda não há questões neste nível
  semQuestoes,
}

/// Dados de um nível para calcular o estado.
class DadosNivel {
  const DadosNivel({required this.numero, required this.numQuestoes, this.notaMinima, this.melhorPercentagem});

  final int numero;
  final int numQuestoes;

  /// null = usar a nota mínima padrão
  final int? notaMinima;

  /// Melhor nota já tirada (null = nunca jogou)
  final double? melhorPercentagem;
}

class Regras {
  const Regras({this.notaMinimaPadrao = notaMinimaPadraoOmissao, this.niveisGratis = niveisGratisOmissao});

  final int notaMinimaPadrao;
  final int niveisGratis;

  int notaMinima(DadosNivel n) => n.notaMinima ?? notaMinimaPadrao;

  bool passou(DadosNivel n) => n.melhorPercentagem != null && n.melhorPercentagem! >= notaMinima(n);

  bool eGratis(int numero) => numero <= niveisGratis;

  /// Estado de cada nível da prova.
  ///
  /// - Nível 1 abre sempre; o N+1 abre quando o N foi passado com nota ≥ mínima (do nível N).
  /// - Níveis acima de [niveisGratis] exigem licença válida E o pacote descarregado.
  List<EstadoNivel> estados(List<DadosNivel> niveis, {required bool temLicenca, required bool pacoteInstalado}) {
    final ordenados = [...niveis]..sort((a, b) => a.numero.compareTo(b.numero));
    final out = <EstadoNivel>[];
    for (var i = 0; i < ordenados.length; i++) {
      final n = ordenados[i];
      final anteriorPassado = i == 0 || passou(ordenados[i - 1]);
      if (!anteriorPassado) {
        out.add(EstadoNivel.bloqueado);
      } else if (!eGratis(n.numero) && !temLicenca) {
        out.add(EstadoNivel.pago);
      } else if (!eGratis(n.numero) && !pacoteInstalado) {
        out.add(EstadoNivel.porDescarregar);
      } else if (n.numQuestoes == 0) {
        out.add(EstadoNivel.semQuestoes);
      } else if (passou(n)) {
        out.add(EstadoNivel.concluido);
      } else {
        out.add(EstadoNivel.disponivel);
      }
    }
    return out;
  }

  /// percentagem = certas (sem ter visto a resposta) / total × 100.
  static double percentagem({required int total, required int certasSemVerResposta}) =>
      total == 0 ? 0 : certasSemVerResposta * 100 / total;
}
