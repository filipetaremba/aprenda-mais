import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

/// Tela 15 — Perfil e definições (tab).
class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  bool _escuro = false;
  bool _lembrete = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        BlueHeader(
          padding: const EdgeInsets.fromLTRB(20, 20, 24, 24),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF1C7),
                    shape: BoxShape.circle,
                  ),
                  child: const Text('🦁', style: TextStyle(fontSize: 34)),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Filipe',
                        style: TextStyle(
                            color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                    Text('A estudar há 12 dias',
                        style: TextStyle(color: Color(0xDDFFFFFF), fontSize: 13)),
                  ],
                ),
              ),
              PillButton(
                label: 'Editar',
                background: Colors.white.withValues(alpha: 0.2),
                onPressed: () => Navigator.of(context).pushNamed(Routes.nome),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Rotulo('OS MEUS OBJECTIVOS'),
              const AppCard(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    EmojiBox('💻', background: AppColors.primary, size: 40, fontSize: 18),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Eng. Informática',
                              style: TextStyle(fontSize: 15, color: AppColors.ink)),
                          Text('UniZambeze · activo',
                              style: TextStyle(fontSize: 12, color: AppColors.muted)),
                        ],
                      ),
                    ),
                    CircleAvatar(radius: 5, backgroundColor: AppColors.success),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Navigator.of(context).pushNamed(Routes.objectivos),
                child: CustomPaint(
                  painter: _DashedBorder(),
                  child: const SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: Center(
                      child: Text('+ Adicionar objectivo',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const _Rotulo('PREFERÊNCIAS'),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _Linha('🌙', 'Modo escuro',
                        AppSwitch(value: _escuro, onChanged: (v) => setState(() => _escuro = v))),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    _Linha('⏰', 'Lembrete de estudo · 19:00',
                        AppSwitch(value: _lembrete, onChanged: (v) => setState(() => _lembrete = v))),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    _Linha(
                      '⬇️',
                      'Actualizações de conteúdo',
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('1 NOVA',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.ink)),
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    const _Linha('ℹ️', 'Sobre o Aprova+',
                        Icon(Icons.chevron_right, color: AppColors.muted)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pushNamed(Routes.devTelas),
                  child: const Text('Ver todas as telas (dev)',
                      style: TextStyle(color: AppColors.muted, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Rotulo extends StatelessWidget {
  const _Rotulo(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(texto,
            style: const TextStyle(
                fontSize: 12,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w700,
                color: AppColors.muted)),
      );
}

class _Linha extends StatelessWidget {
  const _Linha(this.emoji, this.texto, this.trailing);

  final String emoji;
  final String texto;
  final Widget trailing;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 14),
            Expanded(
                child: Text(texto, style: const TextStyle(fontSize: 14, color: AppColors.ink))),
            trailing,
          ],
        ),
      );
}

class _DashedBorder extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(20));
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.border;
    for (final m in path.computeMetrics()) {
      for (double d = 0; d < m.length; d += 10) {
        canvas.drawPath(m.extractPath(d, d + 5), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
