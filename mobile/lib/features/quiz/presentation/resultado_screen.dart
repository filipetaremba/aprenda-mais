import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

/// Tela 10 — Resultado.
class ResultadoScreen extends StatelessWidget {
  const ResultadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 210,
                      child: Stack(
                        children: [
                          const Positioned.fill(child: Confetti()),
                          Center(
                            child: RingProgress(
                              value: 0.8,
                              size: 180,
                              stroke: 22,
                              center: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text('80%',
                                      style: TextStyle(
                                          fontSize: 38,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primary,
                                          height: 1.1)),
                                  Text('16 de 20',
                                      style: TextStyle(fontSize: 12, color: AppColors.muted)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('🎉 Nível 5 desbloqueado!',
                            style: TextStyle(
                                color: AppColors.success,
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text('Muito bem, Filipe!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.ink)),
                    const Text('Matemática · Nível 4 concluído',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: AppColors.muted)),
                    const SizedBox(height: 22),
                    const Row(
                      children: [
                        Expanded(
                            child: StatTile(
                                value: '16',
                                label: 'certas',
                                color: AppColors.success,
                                background: AppColors.successLight)),
                        SizedBox(width: 8),
                        Expanded(
                            child: StatTile(
                                value: '3',
                                label: 'erradas',
                                color: AppColors.error,
                                background: AppColors.errorLight)),
                        SizedBox(width: 8),
                        Expanded(
                            child: StatTile(
                                value: '1',
                                label: 'com ajuda',
                                color: Color(0xFFF59E0B),
                                background: Color(0xFFFFFBEB))),
                        SizedBox(width: 8),
                        Expanded(
                            child: StatTile(
                                value: '18′',
                                label: 'tempo',
                                color: AppColors.primary,
                                background: AppColors.primaryLight)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('A pergunta em que viste a resposta não conta para a nota.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: AppColors.muted)),
                  ],
                ),
              ),
              SecondaryButton(
                label: 'Rever respostas',
                height: 48,
                onPressed: () => Navigator.of(context).pushNamed(Routes.revisao),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'Continuar para o Nível 5',
                onPressed: () => Navigator.of(context).popUntil(
                  (r) => r.settings.name == Routes.niveis || r.isFirst,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
