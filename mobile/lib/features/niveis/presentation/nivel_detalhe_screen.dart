import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

/// Tela 7 — Detalhe do nível.
class NivelDetalheScreen extends StatelessWidget {
  const NivelDetalheScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      padding: const EdgeInsets.fromLTRB(16, 8, 24, 72),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HeaderIconButton(icon: Icons.chevron_left, color: Colors.white),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Text('4',
                                      style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w800)),
                                ),
                                const SizedBox(width: 14),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Matemática · Nível 4',
                                          style: TextStyle(
                                              color: Color(0xDDFFFFFF), fontSize: 12)),
                                      Text('Exercícios semelhantes aos exames',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              height: 1.25,
                                              fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: -44,
                      child: AppCard(
                        elevated: true,
                        radius: 24,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                        child: const Row(
                          children: [
                            _Info('20', 'perguntas'),
                            _Info('~25′', 'duração'),
                            _Info('70%', 'para passar', color: AppColors.primary),
                            _Info('2', 'tentativas'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 64),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle('Temas deste nível'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final t in [
                            'Equações quadráticas',
                            'Funções',
                            'Trigonometria',
                            'Geometria plana',
                          ])
                            ChipFilter(label: t),
                        ],
                      ),
                      const SizedBox(height: 22),
                      const SectionTitle('As tuas tentativas'),
                      const SizedBox(height: 10),
                      const _Tentativa('🟡', AppColors.accentLight, '60% · 12 de 20', 'Ontem · 22 min'),
                      const SizedBox(height: 10),
                      const _Tentativa('🔴', AppColors.errorLight, '45% · 9 de 20', '3 Nov · 27 min'),
                      const SizedBox(height: 16),
                      const InfoBanner(
                        child: Text.rich(TextSpan(children: [
                          TextSpan(text: '💡 Podes usar '),
                          TextSpan(text: 'dicas', style: TextStyle(fontWeight: FontWeight.w700)),
                          TextSpan(text: ' e '),
                          TextSpan(
                              text: 'ver a resposta',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                          TextSpan(
                              text: '. As perguntas em que vires a resposta não contam para a nota.'),
                        ])),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
              child: PrimaryButton(
                label: 'Começar nível',
                onPressed: () => Navigator.of(context).pushNamed(Routes.quiz),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info(this.value, this.label, {this.color = AppColors.ink});

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
          FittedBox(
            child: Text(label, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
          ),
        ],
      ),
    );
  }
}

class _Tentativa extends StatelessWidget {
  const _Tentativa(this.emoji, this.bg, this.titulo, this.sub);

  final String emoji;
  final Color bg;
  final String titulo;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          EmojiBox(emoji, background: bg, size: 40, fontSize: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: const TextStyle(fontSize: 14, color: AppColors.ink)),
                Text(sub, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
              ],
            ),
          ),
          const Text('Não passou',
              style: TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
