import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Barra segmentada: amarelo = feito, azul = actual, claro = por fazer.
class SegmentedProgressBar extends StatelessWidget {
  const SegmentedProgressBar({
    super.key,
    required this.total,
    required this.done,
    this.current = true,
    this.height = 6,
    this.gap = 4,
  });

  final int total;
  final int done;
  final bool current;
  final double height;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < total; i++) ...[
          if (i > 0) SizedBox(width: gap),
          Expanded(
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: i < done
                    ? AppColors.accent
                    : (i == done && current)
                        ? AppColors.primary
                        : AppColors.primaryLight,
                borderRadius: BorderRadius.circular(height),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Barra simples contínua (cabeçalho dos níveis, passos do onboarding).
class LinearBar extends StatelessWidget {
  const LinearBar({
    super.key,
    required this.value,
    this.color = AppColors.accent,
    this.background = const Color(0x55FFFFFF),
    this.height = 8,
  });

  final double value;
  final Color color;
  final Color background;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Container(color: background),
            FractionallySizedBox(
              widthFactor: value.clamp(0, 1),
              child: Container(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

/// Círculo de percentagem.
class RingProgress extends StatelessWidget {
  const RingProgress({
    super.key,
    required this.value,
    required this.size,
    this.stroke = 12,
    this.center,
  });

  final double value;
  final double size;
  final double stroke;
  final Widget? center;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(value, stroke),
        child: Center(child: center),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.value, this.stroke);

  final double value;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final outer = size.width / 2;
    // anel exterior fino
    canvas.drawCircle(
      c,
      outer - 2,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = AppColors.primarySoft.withValues(alpha: 0.9),
    );
    final r = outer - 4 - stroke / 2;
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = AppColors.primaryLight;
    canvas.drawCircle(c, r, track);
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = AppColors.primary;
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      -math.pi / 2,
      2 * math.pi * value.clamp(0, 1),
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.stroke != stroke;
}
