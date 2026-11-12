import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_palette.dart';

abstract final class AppTheme {
  static ThemeData of(AppPalette p) {
    final brightness = p.isDark ? Brightness.dark : Brightness.light;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppPalette.light.primary,
          brightness: brightness,
        ).copyWith(
          primary: p.primary,
          onPrimary: p.isDark ? p.background : AppPalette.onAccent,
          surface: p.card,
          onSurface: p.textPrimary,
          error: p.danger,
          outline: p.border,
          outlineVariant: p.border,
          primaryContainer: p.primaryContainer,
          onPrimaryContainer: p.onPrimaryContainer,
        );
    final radius = BorderRadius.circular(AppRadius.lg);
    final base = ThemeData(brightness: brightness);
    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.manropeTextTheme(base.textTheme),
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.background,
      canvasColor: p.background,
      dividerColor: p.border,
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        foregroundColor: p.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.card,
        indicatorColor: p.primaryContainer,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: p.card,
        indicatorColor: p.primaryContainer,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.card,
        border: OutlineInputBorder(borderRadius: radius),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: p.border),
        ),
      ),
      dialogTheme: DialogThemeData(backgroundColor: p.card),
      chipTheme: ChipThemeData(
        side: BorderSide(color: p.border),
        backgroundColor: p.card,
      ),
    );
  }
}
