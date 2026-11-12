import 'package:flutter/material.dart';

/// Design tokens extraídos de `design/index.html`, com uma variante escura.
///
/// As cores que mudam com o tema são getters: o tema activo está em [escuro]
/// e a app recria as páginas quando ele muda (ver `app.dart`).
abstract final class AppColors {
  /// Tema activo. Alterar só através do `temaProvider`.
  static bool escuro = false;

  // Cores da marca (iguais nos dois temas)
  static const primary = Color(0xFF3B7BEA);
  static const primaryDark = Color(0xFF2A62C9);
  static const accent = Color(0xFFFFC53D);
  static const success = Color(0xFF22C55E);
  static const error = Color(0xFFEF4444);
  static const muted = Color(0xFF94A3B8);
  static const mpesa = Color(0xFFE60000);
  static const emola = Color(0xFFF7941D);

  // Cores que dependem do tema
  static Color get primaryLight => escuro ? const Color(0xFF1C2E4D) : const Color(0xFFEAF1FE);
  static Color get primarySoft => escuro ? const Color(0xFF29467A) : const Color(0xFFC9DBFB);
  static Color get accentLight => escuro ? const Color(0xFF3A3018) : const Color(0xFFFFF3D6);
  static Color get successLight => escuro ? const Color(0xFF143524) : const Color(0xFFE8F9EE);
  static Color get errorLight => escuro ? const Color(0xFF3D1C1F) : const Color(0xFFFDECEC);
  static Color get ink => escuro ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);
  static Color get inkSoft => escuro ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
  static Color get border => escuro ? const Color(0xFF334155) : const Color(0xFFE5E7EB);
  static Color get locked => escuro ? const Color(0xFF64748B) : const Color(0xFF9CA3AF);
  static Color get background => escuro ? const Color(0xFF0F172A) : const Color(0xFFF5F8FF);
  static Color get surface => escuro ? const Color(0xFF1E293B) : Colors.white;
  static Color get streak => escuro ? const Color(0xFF3B2F22) : const Color(0xFFF8EBD8);
}

abstract final class AppRadius {
  static const card = 20.0;
  static const button = 16.0;
  static const header = 32.0;
}
