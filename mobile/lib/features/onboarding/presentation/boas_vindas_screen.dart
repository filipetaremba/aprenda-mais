import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

/// Tela 2 — Boas-vindas (3 slides).
class BoasVindasScreen extends StatefulWidget {
  const BoasVindasScreen({super.key});

  @override
  State<BoasVindasScreen> createState() => _BoasVindasScreenState();
}

class _BoasVindasScreenState extends State<BoasVindasScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _slides = [
    (
      _Illustration.offline,
      'Estuda sem Internet',
      'Todas as perguntas ficam no teu telemóvel. Só precisas de Internet para pagar.',
    ),
    (
      _Illustration.path,
      'Pratica nível a nível',
      '10 níveis por disciplina, do básico à simulação final. Acerta 70% para desbloquear o próximo.',
    ),
    (
      _Illustration.exam,
      'Treina como no exame',
      'Simulados com tempo e sem ajudas, iguais às provas de admissão.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page == _slides.length - 1) {
      context.go(Routes.nome);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () =>
                      context.go(Routes.nome),
                  child: const Text(
                    'Saltar',
                    style: TextStyle(color: AppColors.muted, fontSize: 14),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _slides.length,
                  onPageChanged: (p) => setState(() => _page = p),
                  itemBuilder: (_, i) {
                    final s = _slides[i];
                    return Column(
                      children: [
                        const SizedBox(height: 8),
                        Expanded(
                          flex: 5,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: _IllustrationView(s.$1),
                          ),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          s.$2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          s.$3,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.muted,
                            height: 1.6,
                          ),
                        ),
                        const Spacer(flex: 1),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < _slides.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _page ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _page ? AppColors.primary : AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: _page == _slides.length - 1 ? 'Começar' : 'Seguinte',
                onPressed: _next,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

enum _Illustration { offline, path, exam }

class _IllustrationView extends StatelessWidget {
  const _IllustrationView(this.kind);

  final _Illustration kind;

  @override
  Widget build(BuildContext context) {
    switch (kind) {
      case _Illustration.offline:
        return const Center(child: Text('📱', style: TextStyle(fontSize: 96)));
      case _Illustration.exam:
        return const Center(child: Text('⏱️', style: TextStyle(fontSize: 96)));
      case _Illustration.path:
        return LayoutBuilder(
          builder: (_, c) {
            Widget at(double fx, double fy, Widget w) => Positioned(
                  left: c.maxWidth * fx - 24,
                  top: c.maxHeight * fy - 24,
                  child: SizedBox(width: 48, height: 48, child: Center(child: w)),
                );
            Widget check() => Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.white),
                );
            return Stack(
              children: [
                at(0.24, 0.76, check()),
                at(0.45, 0.62, check()),
                at(0.68, 0.52, Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Text('3',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                )),
                at(0.6, 0.32, Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primarySoft, width: 3),
                  ),
                  child: const Icon(Icons.lock, size: 16, color: AppColors.muted),
                )),
                at(0.55, 0.25, const Text('⭐', style: TextStyle(fontSize: 22))),
              ],
            );
          },
        );
    }
  }
}
