/// Configuração de compilação (--dart-define).
///
///   `flutter run --dart-define=API_URL=http://192.168.1.10:3000`
///   `--dart-define=LICENCA_CHAVE_PUBLICA=(base64 de 32 bytes)`
abstract final class AppConfig {
  /// Endereço do backend (sem "/" no fim). Só é usado para activar, restaurar e actualizar.
  /// Por omissão: o PC visto do emulador Android.
  static const apiUrl = String.fromEnvironment('API_URL', defaultValue: 'http://10.0.2.2:3000');

  /// Chave pública Ed25519 (32 bytes, base64) que verifica as licenças OFFLINE.
  /// A de omissão é a de DESENVOLVIMENTO (backend/.env local); em produção passa a real.
  static const chavePublicaLicencas = String.fromEnvironment(
    'LICENCA_CHAVE_PUBLICA',
    defaultValue: '/argyWDw/AKmmC8L81ntvYCp+ii7dbmvAPdOSTWUasM=',
  );

  /// Pagamento automático M-Pesa/e-Mola (telas 17–18). Desligado nesta fase:
  /// o estudante paga por fora e recebe um código de activação.
  static const pagamentoAutomatico = bool.fromEnvironment('PAGAMENTO_AUTOMATICO', defaultValue: false);

  /// Contactos por omissão (antes de a app falar com o /catalogo).
  static const contactoWhatsapp = String.fromEnvironment('CONTACTO_WHATSAPP', defaultValue: '');
}
