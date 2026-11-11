import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

/// Tela 12 — Simulados (tab).
class SimuladosScreen extends StatelessWidget {
  const SimuladosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void iniciar() => Navigator.of(context).pushNamed(Routes.simulado);
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const BlueHeader(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Simulados',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
              SizedBox(height: 2),
              Text('Como no dia do exame: tempo limitado e sem ajudas.',
                  style: TextStyle(color: Color(0xDDFFFFFF), fontSize: 14)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SimuladoCard(
                emoji: '📐',
                emojiBg: AppColors.primaryLight,
                titulo: 'Prova de Matemática',
                sub: 'UniZambeze · 40 perguntas · 90 min',
                rodape: const Text.rich(TextSpan(children: [
                  TextSpan(text: 'Última: '),
                  TextSpan(text: '72%', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
                ])),
                onIniciar: iniciar,
              ),
              const SizedBox(height: 12),
              _SimuladoCard(
                emoji: '⚛️',
                emojiBg: AppColors.accentLight,
                titulo: 'Prova de Física',
                sub: 'UniZambeze · 40 perguntas · 90 min',
                rodape: const Text.rich(TextSpan(children: [
                  TextSpan(text: 'Última: '),
                  TextSpan(text: '58%', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
                ])),
                onIniciar: iniciar,
              ),
              const SizedBox(height: 12),
              _SimuladoCard(
                escuro: true,
                emoji: '🎯',
                emojiBg: Colors.white.withValues(alpha: 0.12),
                titulo: 'Simulado completo',
                novo: true,
                sub: 'Matemática + Física · 80 perguntas · 3 h',
                rodape: const Text('Ainda não feito'),
                onIniciar: () => Navigator.of(context).pushNamed(Routes.desbloquear),
              ),
              const SizedBox(height: 22),
              const SectionTitle('Últimos resultados'),
              const SizedBox(height: 10),
              AppCard(
                padding: const EdgeInsets.all(12),
                onTap: () => Navigator.of(context).pushNamed(Routes.revisao),
                child: const Row(
                  children: [
                    EmojiBox('72%',
                        background: AppColors.successLight, size: 40, fontSize: 12),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Matemática', style: TextStyle(fontSize: 15, color: AppColors.ink)),
                          Text('5 Nov · 84 min',
                              style: TextStyle(fontSize: 12, color: AppColors.muted)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SimuladoCard extends StatelessWidget {
  const _SimuladoCard({
    required this.emoji,
    required this.emojiBg,
    required this.titulo,
    required this.sub,
    required this.rodape,
    required this.onIniciar,
    this.escuro = false,
    this.novo = false,
  });

  final String emoji;
  final Color emojiBg;
  final String titulo;
  final String sub;
  final Widget rodape;
  final VoidCallback onIniciar;
  final bool escuro;
  final bool novo;

  @override
  Widget build(BuildContext context) {
    final fg = escuro ? Colors.white : AppColors.ink;
    final sub2 = escuro ? const Color(0xCCFFFFFF) : AppColors.muted;
    return AppCard(
      color: escuro ? const Color(0xFF2B3A52) : Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EmojiBox(emoji, background: emojiBg),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      children: [
                        Text(titulo,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700, color: fg)),
                        if (novo)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text('NOVO',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink)),
                          ),
                      ],
                    ),
                    Text(sub, style: TextStyle(fontSize: 12, color: sub2)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DefaultTextStyle.merge(
                  style: TextStyle(fontSize: 12, color: sub2),
                  child: rodape,
                ),
              ),
              PillButton(
                label: 'Iniciar',
                onPressed: onIniciar,
                background: escuro ? Colors.white : AppColors.primary,
                foreground: escuro ? AppColors.ink : Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
