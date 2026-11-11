import 'package:flutter/material.dart';

/// Design tokens extraídos de `design/index.html`.
abstract final class AppColors {
  static const primary = Color(0xFF3B7BEA);
  static const primaryDark = Color(0xFF2A62C9);
  static const primaryLight = Color(0xFFEAF1FE);
  static const primarySoft = Color(0xFFC9DBFB);
  static const accent = Color(0xFFFFC53D);
  static const accentLight = Color(0xFFFFF3D6);
  static const success = Color(0xFF22C55E);
  static const successLight = Color(0xFFE8F9EE);
  static const error = Color(0xFFEF4444);
  static const errorLight = Color(0xFFFDECEC);
  static const ink = Color(0xFF1E293B);
  static const inkSoft = Color(0xFF334155);
  static const muted = Color(0xFF94A3B8);
  static const border = Color(0xFFE5E7EB);
  static const locked = Color(0xFF9CA3AF);
  static const background = Color(0xFFF5F8FF);
  static const surface = Colors.white;
  static const mpesa = Color(0xFFE60000);
  static const emola = Color(0xFFF7941D);
  static const streak = Color(0xFFF8EBD8);
}

abstract final class AppRadius {
  static const card = 20.0;
  static const button = 16.0;
  static const header = 32.0;
}
