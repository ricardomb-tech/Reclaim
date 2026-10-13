import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFF0E1013);
  static const surface = Color(0xFF171A1F);
  static const accent = Color(0xFF7CC4A4); // verde calmado
  static const textMuted = Color(0xFF8A919C);
}

abstract final class AppTheme {
  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: Brightness.dark,
    ).copyWith(
      surface: AppColors.surface,
      primary: AppColors.accent,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: Color(0x337CC4A4),
      ),
    );
  }
}
