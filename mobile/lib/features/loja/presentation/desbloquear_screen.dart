import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

/// Tela 16 — Desbloquear (paywall). Preços virão do seed.
class DesbloquearScreen extends StatefulWidget {
  const DesbloquearScreen({super.key});

  @override
  State<DesbloquearScreen> createState() => _DesbloquearScreenState();
}

class _DesbloquearScreenState extends State<DesbloquearScreen> {
  int _sel = 0;

  static const _opcoes = [
    ('Matemática + Física', 'Tudo para Eng. Informática · inclui simulado completo', 99, 118),
    ('Só Matemática', 'Prova UniZambeze · níveis 3–10 + simulado', 59, null),
  ];

  @override
  Widget build(BuildContext context) {
    final preco = _opcoes[_sel].$3;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    BlueHeader(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: HeaderIconButton(icon: Icons.close, color: Colors.white),
                          ),
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(Icons.lock_open_rounded,
                                color: Colors.white, size: 30),
                          ),
                          const SizedBox(height: 14),
                          const Text('Desbloqueia todos os níveis',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          const Text(
                            'Já concluíste os níveis grátis. Continua até à simulação final!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: -70,
                      child: AppCard(
                        elevated: true,
                        radius: 24,
                        child: Column(
                          children: [
                            for (final b in const [
                              'Níveis 3 a 10 (160 perguntas)',
                              'Simulados com tempo, como no exame',
                              'Explicações e revisão de todas as respostas',
                              'Funciona sem Internet · válido até ao fim da Admissão 2027',
                            ])
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.check, color: AppColors.success, size: 16),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(b,
                                          style: const TextStyle(
                                              fontSize: 13, color: AppColors.ink)),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 96),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      for (var i = 0; i < _opcoes.length; i++) ...[
                        _opcao(i),
                        const SizedBox(height: 14),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
              child: Column(
                children: [
                  PrimaryButton(
                    label: 'Continuar · $preco MT',
                    onPressed: () => Navigator.of(context).pushNamed(Routes.pagamento),
                  ),
                  const SizedBox(height: 8),
                  const Text.rich(
                    TextSpan(children: [
                      TextSpan(text: 'Já compraste noutro telemóvel? '),
                      TextSpan(
                          text: 'Restaurar compra',
                          style: TextStyle(
                              color: AppColors.primary, fontWeight: FontWeight.w700)),
                    ]),
                    style: TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _opcao(int i) {
    final (titulo, sub, preco, antes) = _opcoes[i];
    final sel = i == _sel;
    final recomendado = i == 0;
    final card = AppCard(
      onTap: () => setState(() => _sel = i),
      border: Border.all(
        color: sel ? AppColors.primary : const Color(0xFFEFF2F7),
        width: 2,
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Row(
        children: [
          SelectCircle(selected: sel, radio: true),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
                Text(sub, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (antes != null)
                Text('$antes MT',
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.muted,
                        decoration: TextDecoration.lineThrough)),
              Text('$preco MT',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: recomendado ? AppColors.primary : AppColors.ink)),
            ],
          ),
        ],
      ),
    );
    if (!recomendado) return card;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        card,
        Positioned(
          left: 16,
          top: -11,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('⭐ RECOMENDADO · POUPAS ${antes! - preco} MT',
                style: const TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.ink)),
          ),
        ),
      ],
    );
  }
}
