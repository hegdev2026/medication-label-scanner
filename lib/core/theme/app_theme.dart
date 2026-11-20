import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_palette.dart';

abstract final class AppTheme {
  // Built once per brightness: the theme is rebuilt on every frame of the
  // light/dark fade, and these parts do not depend on the blended colours.
  static final _seeded = <Brightness, ColorScheme>{};
  static final _texts = <Brightness, TextTheme>{};

  static ThemeData of(AppPalette p) {
    final brightness = p.isDark ? Brightness.dark : Brightness.light;
    final seeded = _seeded[brightness] ??= ColorScheme.fromSeed(
      seedColor: AppPalette.light.primary,
      brightness: brightness,
    );
    final textTheme = _texts[brightness] ??= GoogleFonts.manropeTextTheme(
      ThemeData(brightness: brightness).textTheme,
    );
    final scheme = seeded.copyWith(
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
    return ThemeData(
      useMaterial3: true,
      textTheme: textTheme.apply(
        bodyColor: p.textPrimary,
        displayColor: p.textPrimary,
      ),
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
      // Switches stay visible on both themes: a clear off-track outline and a
      // filled primary track when on.
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? (p.isDark ? p.background : AppPalette.onAccent)
              : p.textMuted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.primary : p.inset,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? Colors.transparent
              : p.textMuted,
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
