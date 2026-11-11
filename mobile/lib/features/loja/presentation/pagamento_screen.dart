import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

enum Carteira { mpesa, emola }

/// Detecção da carteira pelo prefixo: 84/85 → M-Pesa, 86/87 → e-Mola.
Carteira? carteiraDoNumero(String numero) {
  final d = numero.replaceAll(RegExp(r'\D'), '');
  if (d.length < 2) return null;
  return switch (d.substring(0, 2)) {
    '84' || '85' => Carteira.mpesa,
    '86' || '87' => Carteira.emola,
    _ => null,
  };
}

/// Tela 17 — Pagamento.
class PagamentoScreen extends StatefulWidget {
  const PagamentoScreen({super.key});

  @override
  State<PagamentoScreen> createState() => _PagamentoScreenState();
}

class _PagamentoScreenState extends State<PagamentoScreen> {
  final _tel = TextEditingController(text: '84 123 4567');
  Carteira _carteira = Carteira.mpesa;

  @override
  void dispose() {
    _tel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detectada = carteiraDoNumero(_tel.text);
    final prefixo = _tel.text.replaceAll(RegExp(r'\D'), '');
    final aviso = switch (detectada) {
      Carteira.mpesa =>
        'Detectámos M-Pesa pelo prefixo ${prefixo.substring(0, 2)}. Usa o número com saldo na carteira.',
      Carteira.emola =>
        'Detectámos e-Mola pelo prefixo ${prefixo.substring(0, 2)}. Usa o número com saldo na carteira.',
      null => prefixo.length >= 2
          ? 'Número não suportado. Usa um número Vodacom (84/85) ou Movitel (86/87).'
          : 'Introduz o teu número de telemóvel.',
    };
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 8, 48, 0),
              child: Row(
                children: [
                  HeaderIconButton(icon: Icons.chevron_left, color: AppColors.ink),
                  Expanded(
                    child: Text('Pagamento',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Vais pagar',
                                  style: TextStyle(fontSize: 12, color: AppColors.muted)),
                              Text('Matemática + Física',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.ink)),
                            ],
                          ),
                        ),
                        Text('99 MT',
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Escolhe a carteira móvel',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: WalletOption(
                          short: 'M-P',
                          name: 'M-Pesa',
                          subtitle: 'Vodacom · 84 / 85',
                          color: AppColors.mpesa,
                          selected: _carteira == Carteira.mpesa,
                          onTap: () => setState(() => _carteira = Carteira.mpesa),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: WalletOption(
                          short: 'e-M',
                          name: 'e-Mola',
                          subtitle: 'Movitel · 86 / 87',
                          color: AppColors.emola,
                          selected: _carteira == Carteira.emola,
                          onTap: () => setState(() => _carteira = Carteira.emola),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Número de telemóvel',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: Row(
                      children: [
                        const Text('🇲🇿 +258',
                            style: TextStyle(
                                color: AppColors.muted,
                                fontWeight: FontWeight.w700,
                                fontSize: 13)),
                        Container(
                          width: 1,
                          height: 24,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          color: AppColors.border,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _tel,
                            keyboardType: TextInputType.phone,
                            onChanged: (_) => setState(() {
                              final c = carteiraDoNumero(_tel.text);
                              if (c != null) _carteira = c;
                            }),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink),
                            decoration: const InputDecoration(border: InputBorder.none),
                          ),
                        ),
                        if (detectada != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: detectada == Carteira.mpesa
                                  ? AppColors.errorLight
                                  : const Color(0xFFFFF4E5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              detectada == Carteira.mpesa ? 'M-Pesa ✓' : 'e-Mola ✓',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: detectada == Carteira.mpesa
                                      ? AppColors.mpesa
                                      : AppColors.emola),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(aviso,
                      style: TextStyle(
                          fontSize: 12,
                          color: detectada == null && prefixo.length >= 2
                              ? AppColors.error
                              : AppColors.muted)),
                  const SizedBox(height: 16),
                  const InfoBanner(
                    color: Color(0xFFFFF3D6),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(text: '📲 Depois de tocar em '),
                      TextSpan(text: 'Pagar', style: TextStyle(fontWeight: FontWeight.w700)),
                      TextSpan(
                          text: ', vais receber um pedido no teu telemóvel. Introduz o teu '),
                      TextSpan(text: 'PIN', style: TextStyle(fontWeight: FontWeight.w700)),
                      TextSpan(text: ' para confirmar.'),
                    ])),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Column(
                children: [
                  PrimaryButton(
                    label: 'Pagar 99 MT',
                    onPressed: detectada == null
                        ? null
                        : () => Navigator.of(context).pushNamed(Routes.aguardar),
                  ),
                  const SizedBox(height: 8),
                  const Text('🔒 Precisas de Internet só neste passo',
                      style: TextStyle(fontSize: 11, color: AppColors.muted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
