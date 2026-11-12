/// Caminhos das rotas (go_router). Usar os construtores para rotas com parâmetros.
abstract final class Routes {
  static const splash = '/splash';
  static const boasVindas = '/boas-vindas';
  static const nome = '/nome';
  static const objectivos = '/objectivos';
  static const inicio = '/inicio';
  static const loja = '/loja';
  static const activar = '/activar';
  static const sincronizar = '/sincronizar';
  static const concluido = '/loja/concluido';
  static const pagamento = '/loja/pagamento';
  static const aguardar = '/loja/aguardar';
  static const devTelas = '/dev/telas';
  static const devWidgets = '/dev/widgets';

  static String inicioTab(int tab) => '$inicio?tab=$tab';
  static String prova(String prova) => '/prova/${Uri.encodeComponent(prova)}';
  static String nivel(String prova, int n) => '/prova/${Uri.encodeComponent(prova)}/nivel/$n';
  static String quiz(String prova, int n) => '/quiz/${Uri.encodeComponent(prova)}/$n';
  static String simulado(String codigo) => '/simulado/${Uri.encodeComponent(codigo)}';
  static String resultado(String tentativa) => '/resultado/$tentativa';
  static String revisao(String tentativa) => '/revisao/$tentativa';
  static String lojaDe(String prova, {String tipo = 'niveis'}) => '$loja?prova=${Uri.encodeComponent(prova)}&tipo=$tipo';
  static String activarPara(String? prova) => prova == null ? activar : '$activar?prova=${Uri.encodeComponent(prova)}';
}
