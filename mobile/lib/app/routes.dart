/// Nomes das rotas (versão estática com Navigator).
///
/// Os parâmetros (`:provaId`, `:tentativaId`, `:ref`…) do mapa de rotas
/// entram na fase de dados; por agora as telas usam dados fictícios.
abstract final class Routes {
  static const splash = '/splash';
  static const boasVindas = '/boas-vindas';
  static const nome = '/nome';
  static const objectivos = '/objectivos/escolher';
  static const inicio = '/inicio';
  static const niveis = '/prova';
  static const nivelDetalhe = '/prova/nivel';
  static const quiz = '/quiz';
  static const resultado = '/quiz/resultado';
  static const revisao = '/quiz/revisao';
  static const simulado = '/simulado';
  static const desbloquear = '/loja/desbloquear';
  static const pagamento = '/loja/pagamento';
  static const aguardar = '/loja/aguardar';
  static const concluido = '/loja/concluido';
  static const devTelas = '/dev/telas';
  static const devWidgets = '/dev/widgets';
}
