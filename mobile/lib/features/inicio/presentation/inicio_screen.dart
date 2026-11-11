import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

/// Tela 5 — Início (tab).
class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            BlueHeader(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Olá, Filipe 👋',
                                style: TextStyle(color: Color(0xDDFFFFFF), fontSize: 14)),
                            Text('Vamos estudar?',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF1C7),
                          shape: BoxShape.circle,
                        ),
                        child: const Text('🦁', style: TextStyle(fontSize: 24)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(children: [
                              TextSpan(text: '💻 Eng. Informática · '),
                              TextSpan(
                                  text: 'UniZambeze',
                                  style: TextStyle(fontWeight: FontWeight.w700)),
                            ]),
                            style: TextStyle(color: Colors.white, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text('Trocar',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: -86,
              child: AppCard(
                elevated: true,
                radius: 24,
                child: Row(
                  children: [
                    const RingProgress(
                      value: 0.30,
                      size: 72,
                      stroke: 9,
                      center: Text('30%',
                          style: TextStyle(
                              color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Progresso geral',
                              style: TextStyle(fontSize: 11, color: AppColors.muted)),
                          const Text('6 de 20 níveis concluídos',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink)),
                          const SizedBox(height: 8),
                          Material(
                            color: AppColors.primary,
                            shape: const StadiumBorder(),
                            child: InkWell(
                              customBorder: const StadiumBorder(),
                              onTap: () => Navigator.of(context).pushNamed(Routes.nivelDetalhe),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Text(
                                  '▶ Continuar: Matemática · Nível 4',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                                ),
                              ),
                            ),
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
        const SizedBox(height: 108),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SectionTitle('As tuas provas', trailing: '2 disciplinas'),
              const SizedBox(height: 12),
              _ProvaCard(
                emoji: '📐',
                bg: AppColors.primaryLight,
                nome: 'Matemática',
                info: 'Nível 4 de 10 · Melhor: 82%',
                feitos: 3,
                onTap: () => Navigator.of(context).pushNamed(Routes.niveis),
              ),
              const SizedBox(height: 12),
              _ProvaCard(
                emoji: '⚛️',
                bg: AppColors.accentLight,
                nome: 'Física',
                info: 'Nível 2 de 10 · Melhor: 65%',
                feitos: 1,
                onTap: () => Navigator.of(context).pushNamed(Routes.niveis),
              ),
              const SizedBox(height: 12),
              const InfoBanner(
                child: Row(
                  children: [
                    Text('🔥', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: '6 dias seguidos! ',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        TextSpan(text: 'Faz 1 nível hoje para manter a sequência.'),
                      ])),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 110),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProvaCard extends StatelessWidget {
  const _ProvaCard({
    required this.emoji,
    required this.bg,
    required this.nome,
    required this.info,
    required this.feitos,
    this.onTap,
  });

  final String emoji;
  final Color bg;
  final String nome;
  final String info;
  final int feitos;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              EmojiBox(emoji, background: bg),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nome,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
                    Text(info, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 14),
          SegmentedProgressBar(total: 10, done: feitos, height: 5),
        ],
      ),
    );
  }
}
