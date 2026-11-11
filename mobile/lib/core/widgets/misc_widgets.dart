import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

enum LevelState { done, current, locked }

/// Círculo de um nível no caminho em zig-zag.
class LevelNode extends StatelessWidget {
  const LevelNode({
    super.key,
    required this.number,
    required this.state,
    this.onTap,
  });

  final int number;
  final LevelState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget node = switch (state) {
      LevelState.done => Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.success.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 30),
        ),
      LevelState.current => Container(
          width: 96,
          height: 96,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primarySoft.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      LevelState.locked => Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border, width: 2),
          ),
          child: const Icon(Icons.lock_outline_rounded,
              color: AppColors.muted, size: 22),
        ),
    };
    return GestureDetector(onTap: onTap, child: node);
  }
}

/// Estrelas conforme a melhor nota (≥90 ★★★, ≥80 ★★, resto ★).
class StarRow extends StatelessWidget {
  const StarRow(this.percent, {super.key});

  final int percent;

  @override
  Widget build(BuildContext context) {
    final n = percent >= 90 ? 3 : (percent >= 80 ? 2 : 1);
    return Text('⭐' * n, style: const TextStyle(fontSize: 11));
  }
}

/// Mosaico de estatística (número grande + legenda).
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.value,
    required this.label,
    required this.color,
    required this.background,
  });

  final String value;
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          FittedBox(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

/// Filtro em forma de pílula.
class ChipFilter extends StatelessWidget {
  const ChipFilter({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.color = AppColors.primary,
    this.background = AppColors.primaryLight,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? color : background,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : color,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// Barra inferior: Início · Simulados · Progresso · Perfil.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    (Icons.home_outlined, 'Início'),
    (Icons.timer_outlined, 'Simulados'),
    (Icons.bar_chart_rounded, 'Progresso'),
    (Icons.person_outline_rounded, 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A1E50).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => onTap(i),
                    child: _NavItem(
                      icon: _items[i].$1,
                      label: _items[i].$2,
                      active: i == currentIndex,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, required this.active});

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.muted;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

/// Cartão de escolha de carteira móvel (M-Pesa / e-Mola).
class WalletOption extends StatelessWidget {
  const WalletOption({
    super.key,
    required this.short,
    required this.name,
    required this.subtitle,
    required this.color,
    this.selected = false,
    this.onTap,
  });

  final String short;
  final String name;
  final String subtitle;
  final Color color;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFFDF0F0) : Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? color : const Color(0xFFEFF2F7),
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      short,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppColors.ink,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: AppColors.muted),
                  ),
                ],
              ),
              if (selected)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    child: const Icon(Icons.check, color: Colors.white, size: 14),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Interruptor simples com as cores do design.
class AppSwitch extends StatelessWidget {
  const AppSwitch({super.key, required this.value, this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 44,
        height: 26,
        padding: const EdgeInsets.all(3),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
          color: value ? AppColors.primary : const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

/// Círculo de selecção (rádio / visto) usado em listas.
class SelectCircle extends StatelessWidget {
  const SelectCircle({super.key, required this.selected, this.radio = false});

  final bool selected;
  final bool radio;

  @override
  Widget build(BuildContext context) {
    if (!selected) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border, width: 2),
        ),
      );
    }
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: radio
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : const Icon(Icons.check, color: Colors.white, size: 15),
    );
  }
}

/// Confettis decorativos (telas 10 e 19).
class Confetti extends StatelessWidget {
  const Confetti({super.key});

  @override
  Widget build(BuildContext context) {
    Widget dot(Color c, double s, {bool square = false, double angle = 0}) =>
        Transform.rotate(
          angle: angle,
          child: Container(
            width: s,
            height: square ? s * 1.3 : s,
            decoration: BoxDecoration(
              color: c,
              shape: square ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: square ? BorderRadius.circular(2) : null,
            ),
          ),
        );
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(left: 40, top: 20, child: dot(AppColors.accent, 9, square: true, angle: 0.2)),
          Positioned(left: 96, top: 52, child: dot(AppColors.primary, 8)),
          Positioned(left: 64, top: 118, child: dot(AppColors.primary, 9, square: true, angle: 0.8)),
          Positioned(right: 52, top: 30, child: dot(AppColors.success, 8, square: true, angle: -0.3)),
          Positioned(right: 96, top: 70, child: dot(AppColors.error, 8)),
          Positioned(right: 64, top: 130, child: dot(AppColors.accent, 9, square: true, angle: 0.8)),
          Positioned(left: 0, right: 0, top: 6, child: Center(child: dot(AppColors.success, 8))),
        ],
      ),
    );
  }
}
