import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Cartão branco com cantos arredondados e sombra suave.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.radius = AppRadius.card,
    this.border,
    this.onTap,
    this.elevated = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  /// null = superfície do tema
  final Color? color;
  final double radius;
  final BoxBorder? border;
  final VoidCallback? onTap;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(radius);
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: shape,
        border: border,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A1E50).withValues(alpha: elevated ? 0.12 : 0.04),
            blurRadius: elevated ? 24 : 10,
            offset: Offset(0, elevated ? 10 : 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: shape,
        child: InkWell(
          borderRadius: shape,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Cabeçalho azul com cantos inferiores arredondados.
class BlueHeader extends StatelessWidget {
  const BlueHeader({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(24, 16, 24, 28),
    this.radius = AppRadius.header,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(radius)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Caixa de aviso amarelada (dicas, sequência de dias, etc.).
class InfoBanner extends StatelessWidget {
  const InfoBanner({
    super.key,
    required this.child,
    this.color,
  });

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color ?? AppColors.streak,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: AppColors.ink, fontSize: 13, height: 1.5),
        child: child,
      ),
    );
  }
}

/// Ícone emoji dentro de um quadrado arredondado colorido.
class EmojiBox extends StatelessWidget {
  const EmojiBox(
    this.emoji, {
    super.key,
    this.background,
    this.size = 44,
    this.fontSize = 22,
  });

  final String emoji;
  final Color? background;
  final double size;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background ?? AppColors.primaryLight,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Text(emoji, style: TextStyle(fontSize: fontSize)),
    );
  }
}

/// Título de secção ("As tuas provas", "Temas deste nível"…).
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing});

  final String text;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: const TextStyle(fontSize: 12, color: AppColors.muted),
          ),
      ],
    );
  }
}
