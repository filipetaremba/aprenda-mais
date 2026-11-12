import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'conteudo.dart';

enum OptionState { normal, selected, correct, wrong }

/// Alternativa de resposta com letra A–D (ou ícone ✓/✕ após correcção).
class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.letter,
    required this.text,
    this.state = OptionState.normal,
    this.onTap,
    this.compact = false,
    this.imagem,
  });

  final String letter;
  final String text;

  /// Imagem da alternativa (nome do ficheiro), quando a alternativa é uma figura.
  final String? imagem;
  final OptionState state;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final (bg, border, badgeBg, badgeFg) = switch (state) {
      OptionState.normal => (
          AppColors.surface,
          AppColors.escuro ? AppColors.border : const Color(0xFFEFF2F7),
          AppColors.primaryLight,
          AppColors.primary,
        ),
      OptionState.selected => (
          AppColors.primaryLight,
          AppColors.primary,
          AppColors.primary,
          Colors.white,
        ),
      OptionState.correct => (
          AppColors.successLight,
          AppColors.success,
          AppColors.success,
          Colors.white,
        ),
      OptionState.wrong => (
          AppColors.errorLight,
          AppColors.error,
          AppColors.error,
          Colors.white,
        ),
    };
    final badgeChild = switch (state) {
      OptionState.correct => const Icon(Icons.check, size: 16, color: Colors.white),
      OptionState.wrong => const Icon(Icons.close, size: 16, color: Colors.white),
      _ => Text(
          letter,
          style: TextStyle(
            color: badgeFg,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
    };
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 12 : 16,
            vertical: compact ? 10 : 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border, width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: badgeBg, shape: BoxShape.circle),
                child: badgeChild,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (text.isNotEmpty) MathText(text, style: TextStyle(fontSize: 15, color: AppColors.ink)),
                    if (imagem != null)
                      Padding(
                        padding: EdgeInsets.only(top: text.isEmpty ? 0 : 6),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ColoredBox(color: Colors.white, child: ImagemConteudo(imagem!, altura: 90)),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cartão azul com o enunciado e uma figura opcional.
class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.label,
    required this.text,
    this.figure,
    this.trailing,
  });

  final String label;
  final String text;
  final Widget? figure;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xDDFFFFFF),
                    fontSize: 12,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 6),
          MathText(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.45,
            ),
          ),
          if (figure != null) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 80, maxHeight: 240),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: figure,
            ),
          ],
        ],
      ),
    );
  }
}

/// Folha inferior de feedback (certa/errada) da tela 9.
class BottomSheetFeedback extends StatelessWidget {
  const BottomSheetFeedback({
    super.key,
    required this.correct,
    required this.correctAnswer,
    required this.explanation,
    this.onNext,
  });

  final bool correct;
  final String correctAnswer;
  final String explanation;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final main = correct ? AppColors.success : AppColors.error;
    final bg = correct ? AppColors.successLight : const Color(0xFFFDF0F0);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: main, width: 3)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: main, shape: BoxShape.circle),
                  child: Icon(
                    correct ? Icons.check : Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  correct ? 'Resposta certa!' : 'Resposta errada',
                  style: TextStyle(
                    color: main,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Correcta: ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: correctAnswer),
                ],
              ),
              style: TextStyle(fontSize: 15, color: AppColors.ink),
            ),
            const SizedBox(height: 6),
            MathText(
              explanation,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.inkSoft,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: Material(
                color: main,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: onNext,
                  child: const Center(
                    child: Text(
                      'Seguinte',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
