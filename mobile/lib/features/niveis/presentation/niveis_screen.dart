import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

/// Tela 6 — Níveis da disciplina (caminho em zig-zag).
class NiveisScreen extends StatelessWidget {
  const NiveisScreen({super.key});

  static const _niveis = [
    (1, 'Fundamentos', LevelState.done, 95),
    (2, 'Consolidação', LevelState.done, 85),
    (3, 'Aplicação', LevelState.done, 75),
    (4, 'Estilo de exame', LevelState.current, 0),
    (5, 'Prática', LevelState.locked, 0),
    (6, 'Problemas', LevelState.locked, 0),
    (7, 'Exames anteriores', LevelState.locked, 0),
    (8, 'Revisão geral', LevelState.locked, 0),
    (9, 'Desafio', LevelState.locked, 0),
    (10, 'Simulação final', LevelState.locked, 0),
  ];

  // posição horizontal (0 = esquerda, 1 = direita) de cada nó
  static const _x = [0.0, 0.55, 0.15, 0.5, 0.65, 0.1, 0.5, 0.75, 0.25, 0.5];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BlueHeader(
            padding: const EdgeInsets.fromLTRB(16, 12, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const HeaderIconButton(icon: Icons.chevron_left, color: Colors.white),
                    const Expanded(
                      child: Text('📐 Matemática',
                          style: TextStyle(
                              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('3/10',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: LinearBar(value: 0.3),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text('Prova UniZambeze · 3 níveis concluídos',
                      style: TextStyle(color: Color(0xDDFFFFFF), fontSize: 12)),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth - 48;
                return ListView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
                  children: [
                    Stack(
                      children: [
                        // linha tracejada central
                        Positioned.fill(
                          child: Center(
                            child: CustomPaint(
                              size: const Size(2, double.infinity),
                              painter: _DashPainter(),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            for (var i = 0; i < _niveis.length; i++)
                              _row(context, i, w),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, int i, double w) {
    final (n, titulo, estado, melhor) = _niveis[i];
    void tap() {
      if (estado == LevelState.locked) {
        Navigator.of(context).pushNamed(Routes.desbloquear);
      } else {
        Navigator.of(context).pushNamed(Routes.nivelDetalhe);
      }
    }

    if (estado == LevelState.current) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('COMEÇAR',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11)),
            ),
            const SizedBox(height: 2),
            LevelNode(number: n, state: estado, onTap: tap),
            const SizedBox(height: 4),
            Text(titulo,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.ink)),
          ],
        ),
      );
    }
    final left = _x[i] * (w - 200);
    return Padding(
      padding: EdgeInsets.only(left: left.clamp(0, w), top: 8, bottom: 8),
      child: GestureDetector(
        onTap: tap,
        child: Row(
          children: [
            LevelNode(number: n, state: estado),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$n · $titulo',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: estado == LevelState.done ? FontWeight.w700 : FontWeight.w400,
                      color: estado == LevelState.done ? AppColors.ink : AppColors.muted,
                    ),
                  ),
                  if (estado == LevelState.done)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Melhor $melhor% ',
                            style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                        StarRow(melhor),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = AppColors.primarySoft
      ..strokeWidth = 2;
    for (double y = 0; y < size.height; y += 10) {
      canvas.drawLine(Offset(0, y), Offset(0, y + 5), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
