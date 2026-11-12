import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/widgets.dart';

/// Página interna `/dev/widgets` com os componentes base.
class DevWidgetsPage extends StatelessWidget {
  const DevWidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget t(String s) => Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8),
          child: Text(s,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: AppColors.muted, fontSize: 12)),
        );
    return Scaffold(
      appBar: AppBar(title: const Text('Componentes (dev)')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
        children: [
          t('PrimaryButton / SecondaryButton / PillButton'),
          PrimaryButton(label: 'Continuar', onPressed: () {}),
          const SizedBox(height: 8),
          SecondaryButton(label: 'Rever respostas', onPressed: () {}),
          const SizedBox(height: 8),
          Align(alignment: Alignment.centerLeft, child: PillButton(label: 'Iniciar', onPressed: () {})),
          t('SegmentedProgressBar'),
          const SegmentedProgressBar(total: 10, done: 4),
          t('RingProgress'),
          const Center(
            child: RingProgress(
              value: 0.8,
              size: 100,
              center: Text('80%',
                  style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
            ),
          ),
          t('OptionTile'),
          const OptionTile(letter: 'A', text: '10'),
          const SizedBox(height: 8),
          const OptionTile(letter: 'B', text: '12', state: OptionState.selected),
          const SizedBox(height: 8),
          const OptionTile(letter: 'C', text: '14', state: OptionState.correct),
          const SizedBox(height: 8),
          const OptionTile(letter: 'D', text: '9,6', state: OptionState.wrong),
          t('QuestionCard + MathText'),
          const QuestionCard(
            label: 'Questão 7 · Geometria',
            text: r'Qual é a hipotenusa $x$ se $x^2 = 6^2 + 8^2$?',
            figure: TriangleFigure(),
          ),
          t('LevelNode'),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              LevelNode(number: 1, state: LevelState.done),
              LevelNode(number: 4, state: LevelState.current),
              LevelNode(number: 5, state: LevelState.locked),
            ],
          ),
          t('StatTile'),
          Row(
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
            ],
          ),
          t('ChipFilter'),
          const Wrap(spacing: 8, children: [
            ChipFilter(label: 'Todas', selected: true),
            ChipFilter(label: 'UEM'),
          ]),
          t('WalletOption'),
          const Row(
            children: [
              Expanded(
                child: WalletOption(
                    short: 'M-P',
                    name: 'M-Pesa',
                    subtitle: 'Vodacom · 84 / 85',
                    color: AppColors.mpesa,
                    selected: true),
              ),
              SizedBox(width: 12),
              Expanded(
                child: WalletOption(
                    short: 'e-M',
                    name: 'e-Mola',
                    subtitle: 'Movitel · 86 / 87',
                    color: AppColors.emola),
              ),
            ],
          ),
          t('BottomSheetFeedback'),
          const BottomSheetFeedback(
            correct: false,
            correctAnswer: 'x = −1 e x = 3',
            explanation: 'A parábola corta o eixo em −1 e 3.',
          ),
          t('AppBottomNav'),
          AppBottomNav(currentIndex: 0, onTap: (_) {}),
        ],
      ),
    );
  }
}
