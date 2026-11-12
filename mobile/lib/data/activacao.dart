import 'api.dart';
import 'licencas.dart';
import 'repositorios.dart';

/// Nenhuma das licenças recebidas passou a verificação da assinatura (chave pública errada?).
class LicencaInvalida implements Exception {
  @override
  String toString() => 'A licença recebida não é válida.';
}

/// Activar um código, restaurar compras e verificar actualizações (as únicas acções com Internet).
class ServicoActivacao {
  ServicoActivacao({required this.api, required this.user, required this.licencas});

  final ApiCliente api;
  final UtilizadorRepo user;
  final LicencasRepo licencas;

  /// Activa (ou restaura) e guarda o token e as licenças verificadas. Devolve os pacotes a descarregar.
  Future<({List<Licenca> licencas, List<PacoteRemoto> pacotes, bool restaurado})> activar({
    required String codigo,
    String? telefone,
    String? nome,
  }) async {
    final r = await api.activar(
      codigo: codigo,
      dispositivoId: await user.dispositivoId(),
      telefone: telefone,
      nome: nome,
      token: await user.token(),
    );
    final aceites = await licencas.guardar(r.licencas, substituir: true);
    if (r.licencas.isNotEmpty && aceites.isEmpty) throw LicencaInvalida();
    await user.gravarToken(r.token);
    return (licencas: aceites, pacotes: r.pacotes, restaurado: r.restaurado);
  }

  /// Volta a pedir as licenças ao servidor (as revogadas/expiradas desaparecem) e devolve os pacotes.
  /// Null se ainda não houver nenhuma activação neste telemóvel.
  Future<List<PacoteRemoto>?> actualizar() async {
    final token = await user.token();
    if (token == null) return null;
    final r = await api.licencas(token);
    await licencas.guardar(r.licencas, substituir: true);
    return r.pacotes;
  }

  /// Mensagem clara para o estudante.
  static String mensagemDe(Object e) {
    if (e is SemInternet) return 'Sem Internet. Liga os dados móveis ou o Wi-Fi: só precisas de Internet para activar e descarregar.';
    if (e is LicencaInvalida) return 'A licença recebida não é válida. Actualiza a app ou fala connosco pelo WhatsApp.';
    if (e is ErroApi) {
      return switch (e.codigo) {
        'CODIGO_INVALIDO' => 'Código inválido. Confirma as letras e os números (formato APV-XXXX-XXXX).',
        'DEMASIADAS_TENTATIVAS' => 'Demasiadas tentativas. Espera uma hora e tenta de novo.',
        'NAO_AUTENTICADO' => 'A sessão expirou. Restaura a compra com o teu código e o teu telefone.',
        _ => e.mensagem,
      };
    }
    return 'Ocorreu um erro. Tenta de novo.';
  }
}
