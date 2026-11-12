import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static const fontFamily = 'Poppins';

  /// Tema conforme [AppColors.escuro].
  static ThemeData actual() {
    final escuro = AppColors.escuro;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: escuro ? Brightness.dark : Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      error: AppColors.error,
      surface: AppColors.surface,
    );
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      brightness: escuro ? Brightness.dark : Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: AppColors.ink),
        bodyLarge: TextStyle(color: AppColors.ink),
      ),
      dialogTheme: DialogThemeData(backgroundColor: AppColors.surface),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: AppColors.surface),
      splashFactory: InkRipple.splashFactory,
    );
  }

  static ThemeData light() => actual();
}
