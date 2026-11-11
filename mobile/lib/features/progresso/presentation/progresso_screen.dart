import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

/// Tela 14 — Progresso (tab).
class ProgressoScreen extends StatelessWidget {
  const ProgressoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text('O teu progresso',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.ink)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text('Últimos 7 dias ▾',
                            style: TextStyle(color: AppColors.primary, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(
                          child: StatTile(
                              value: '342',
                              label: 'respostas',
                              color: AppColors.primary,
                              background: AppColors.primaryLight)),
                      SizedBox(width: 8),
                      Expanded(
                          child: StatTile(
                              value: '71%',
                              label: 'acertos',
                              color: AppColors.success,
                              background: AppColors.successLight)),
                      SizedBox(width: 8),
                      Expanded(
                          child: StatTile(
                              value: '6',
                              label: 'níveis',
                              color: Color(0xFFF59E0B),
                              background: Color(0xFFFFFBEB))),
                      SizedBox(width: 8),
                      Expanded(
                          child: StatTile(
                              value: '🔥6',
                              label: 'dias',
                              color: AppColors.error,
                              background: AppColors.errorLight)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle('Evolução das notas'),
                    const SizedBox(height: 12),
                    const SizedBox(
                      height: 130,
                      width: double.infinity,
                      child: CustomPaint(painter: _ChartPainter()),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (final d in ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'])
                          Text(d, style: const TextStyle(fontSize: 10, color: AppColors.muted)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle('Temas a reforçar'),
                    SizedBox(height: 12),
                    _Tema('Trigonometria · Mat.', 0.45, AppColors.error, AppColors.errorLight),
                    _Tema('Electricidade · Fís.', 0.52, AppColors.accent, Color(0xFFFFFBEB)),
                    _Tema('Logaritmos · Mat.', 0.58, AppColors.accent, Color(0xFFFFFBEB)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const SectionTitle('Histórico'),
              const SizedBox(height: 10),
              for (final h in const [
                ('80%', 'Matemática · Nível 4', 'Hoje · 18 min', true),
                ('72%', 'Simulado de Matemática', '5 Nov · 84 min', true),
                ('60%', 'Matemática · Nível 4', 'Ontem · 22 min', false),
                ('65%', 'Física · Nível 2', '3 Nov · 19 min', false),
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        EmojiBox(h.$1,
                            background: h.$4 ? AppColors.successLight : AppColors.accentLight,
                            size: 40,
                            fontSize: 12),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(h.$2,
                                  style: const TextStyle(fontSize: 14, color: AppColors.ink)),
                              Text(h.$3,
                                  style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                            ],
                          ),
                        ),
                        Text(h.$4 ? 'Passou' : 'Não passou',
                            style: TextStyle(
                                fontSize: 12,
                                color: h.$4 ? AppColors.success : AppColors.error)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Tema extends StatelessWidget {
  const _Tema(this.nome, this.valor, this.cor, this.fundo);

  final String nome;
  final double valor;
  final Color cor;
  final Color fundo;

  @override
  Widget build(BuildContext context) {
    final pctColor = cor == AppColors.accent ? const Color(0xFFF59E0B) : cor;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(nome, style: const TextStyle(fontSize: 13, color: AppColors.ink))),
              Text('${(valor * 100).round()}%',
                  style: TextStyle(fontWeight: FontWeight.w700, color: pctColor, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 6),
          LinearBar(value: valor, color: cor, background: fundo, height: 8),
        ],
      ),
    );
  }
}

/// Gráfico de linha simples (na fase 5 passa a `fl_chart`).
class _ChartPainter extends CustomPainter {
  const _ChartPainter();

  static const _valores = [0.45, 0.52, 0.49, 0.61, 0.58, 0.68, 0.72];

  @override
  void paint(Canvas canvas, Size size) {
    double y(double v) => size.height - (v - 0.4) / 0.35 * size.height;
    final grid = Paint()
      ..color = const Color(0xFFE8EEF8)
      ..strokeWidth = 1;
    for (final g in [0.5, 0.6]) {
      canvas.drawLine(Offset(0, y(g)), Offset(size.width, y(g)), grid);
    }
    // linha da nota mínima (70%) tracejada
    final meta = Paint()
      ..color = AppColors.success
      ..strokeWidth = 1.2;
    for (double x = 0; x < size.width; x += 8) {
      canvas.drawLine(Offset(x, y(0.7)), Offset(x + 4, y(0.7)), meta);
    }
    final tp = TextPainter(
      text: const TextSpan(
          text: '70%',
          style: TextStyle(fontSize: 9, color: AppColors.muted, fontFamily: 'Poppins')),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(0, y(0.7) - 13));

    final dx = size.width / (_valores.length - 1);
    final pts = [
      for (var i = 0; i < _valores.length; i++) Offset(i * dx, y(_valores[i])),
    ];
    final area = Path()..moveTo(pts.first.dx, size.height);
    for (final p in pts) {
      area.lineTo(p.dx, p.dy);
    }
    area
      ..lineTo(pts.last.dx, size.height)
      ..close();
    canvas.drawPath(
      area,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0.25),
            AppColors.primary.withValues(alpha: 0.0),
          ],
        ).createShader(Offset.zero & size),
    );
    final line = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final p in pts.skip(1)) {
      line.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(
      line,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeJoin = StrokeJoin.round
        ..color = AppColors.primary,
    );
    canvas.drawCircle(pts.last, 6, Paint()..color = Colors.white);
    canvas.drawCircle(
      pts.last,
      6,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = AppColors.primary,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
