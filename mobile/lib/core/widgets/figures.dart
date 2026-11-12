import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Figuras de exemplo desenhadas em código (no seed real serão imagens).

class TriangleFigure extends StatelessWidget {
  const TriangleFigure({super.key});

  @override
  Widget build(BuildContext context) =>
      const CustomPaint(painter: _TrianglePainter(), size: Size.infinite);
}

class _TrianglePainter extends CustomPainter {
  const _TrianglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final top = Offset(cx - 66, 12);
    final corner = Offset(cx - 66, size.height - 22);
    final right = Offset(cx + 66, size.height - 22);
    final path = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(corner.dx, corner.dy)
      ..lineTo(right.dx, right.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = AppColors.primaryLight);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = AppColors.primaryDark,
    );
    canvas.drawRect(
      Rect.fromLTWH(corner.dx, corner.dy - 14, 14, 14),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = AppColors.primaryDark,
    );
    _label(canvas, '6', Offset(top.dx - 16, (top.dy + corner.dy) / 2 - 8));
    _label(canvas, '8', Offset(cx - 4, corner.dy + 3));
    _label(canvas, 'x', Offset(cx + 4, (top.dy + right.dy) / 2 - 22),
        color: AppColors.primary, italic: true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ParabolaFigure extends StatelessWidget {
  const ParabolaFigure({super.key});

  @override
  Widget build(BuildContext context) =>
      const CustomPaint(painter: _ParabolaPainter(), size: Size.infinite);
}

class _ParabolaPainter extends CustomPainter {
  const _ParabolaPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const unit = 28.0;
    final ox = size.width / 2 - unit * 1.2; // origem
    final oy = size.height * 0.55;
    final grid = Paint()
      ..color = const Color(0xFFE6EDF8)
      ..strokeWidth = 1;
    for (var i = -3; i <= 5; i++) {
      canvas.drawLine(Offset(ox + i * unit, 0), Offset(ox + i * unit, size.height), grid);
    }
    for (var j = -2; j <= 2; j++) {
      canvas.drawLine(Offset(ox - unit * 3.5, oy + j * unit * 0.66),
          Offset(ox + unit * 5.5, oy + j * unit * 0.66), grid);
    }
    final axis = Paint()
      ..color = const Color(0xFF8A97AD)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(ox - unit * 3.5, oy), Offset(ox + unit * 5.5, oy), axis);
    canvas.drawLine(Offset(ox, 0), Offset(ox, size.height), axis);

    // f(x) = (x+1)(x-3)/k
    final path = Path();
    var first = true;
    for (var x = -2.2; x <= 4.2; x += 0.05) {
      final y = (x + 1) * (x - 3) * 0.36;
      final p = Offset(ox + x * unit, oy - y * unit * 0.66 * 1.6);
      if (first) {
        path.moveTo(p.dx, p.dy);
        first = false;
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = AppColors.primary,
    );
    canvas.restore();
    final dot = Paint()..color = AppColors.accent;
    canvas.drawCircle(Offset(ox - unit, oy), 4, dot);
    canvas.drawCircle(Offset(ox + 3 * unit, oy), 4, dot);
    _label(canvas, '−1', Offset(ox - unit - 8, oy + 4), size: 10);
    _label(canvas, '1', Offset(ox + unit - 3, oy + 4), size: 10);
    _label(canvas, '3', Offset(ox + 3 * unit + 4, oy + 4), size: 10);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CircuitFigure extends StatelessWidget {
  const CircuitFigure({super.key});

  @override
  Widget build(BuildContext context) =>
      const CustomPaint(painter: _CircuitPainter(), size: Size.infinite);
}

class _CircuitPainter extends CustomPainter {
  const _CircuitPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final wire = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.ink;
    final res = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.primary;
    final l = size.width / 2 - 64;
    final r = size.width / 2 + 64;
    const t = 14.0;
    final b = size.height - 14;
    final midY = (t + b) / 2;

    // fio de cima com resistência R1
    canvas.drawLine(Offset(l, t), Offset(size.width / 2 - 18, t), wire);
    final zz = Path()..moveTo(size.width / 2 - 18, t);
    for (var i = 0; i < 6; i++) {
      zz.lineTo(size.width / 2 - 18 + 3 + i * 6, t + (i.isEven ? -7 : 7));
    }
    zz.lineTo(size.width / 2 + 18, t);
    canvas.drawPath(zz, res);
    canvas.drawLine(Offset(size.width / 2 + 18, t), Offset(r, t), wire);
    // lado direito com R2
    canvas.drawLine(Offset(r, t), Offset(r, midY - 18), wire);
    final zz2 = Path()..moveTo(r, midY - 18);
    for (var i = 0; i < 6; i++) {
      zz2.lineTo(r + (i.isEven ? 7 : -7), midY - 18 + 3 + i * 6);
    }
    zz2.lineTo(r, midY + 18);
    canvas.drawPath(zz2, res);
    canvas.drawLine(Offset(r, midY + 18), Offset(r, b), wire);
    // fundo
    canvas.drawLine(Offset(r, b), Offset(l, b), wire);
    // lado esquerdo com bateria
    canvas.drawLine(Offset(l, b), Offset(l, midY + 8), wire);
    canvas.drawLine(Offset(l, t), Offset(l, midY - 8), wire);
    canvas.drawLine(Offset(l - 12, midY - 8), Offset(l + 12, midY - 8),
        Paint()..color = AppColors.ink..strokeWidth = 2);
    canvas.drawLine(Offset(l - 6, midY + 4), Offset(l + 6, midY + 4),
        Paint()..color = AppColors.ink..strokeWidth = 4);

    _label(canvas, '12 V', Offset(l + 16, midY - 6), size: 10);
    _label(canvas, 'R₁ = 4 Ω', Offset(size.width / 2 - 20, t + 10),
        size: 10, color: AppColors.primary);
    _label(canvas, 'R₂ = 2 Ω', Offset(r - 62, midY - 6),
        size: 10, color: AppColors.primary);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void _label(
  Canvas canvas,
  String text,
  Offset at, {
  double size = 13,
  Color? color,
  bool italic = false,
}) {
  final tp = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: size,
        color: color ?? AppColors.ink,
        fontWeight: FontWeight.w700,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  tp.paint(canvas, at);
}
