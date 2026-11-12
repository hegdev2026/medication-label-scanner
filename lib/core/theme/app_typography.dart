import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';

class AppFontWeight {
  const AppFontWeight._();
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

class AppFontSize {
  const AppFontSize._();
  static const double micro = 10;
  static const double xs = 11;
  static const double sm = 12;
  static const double md = 14;
  static const double lg = 16;
  static const double title = 18;
  static const double xl = 22;
  static const double xxl = 26;
  static const double display = 32;
}

/// Type roles (Manrope). Colour comes from [AppColors] unless overridden with
/// `.tinted`. Figures use tabular numerals so dosages and dates line up.
class AppText {
  const AppText._();

  static const _tabular = [FontFeature.tabularFigures()];

  static TextStyle _style({
    required double size,
    required FontWeight weight,
    required Color color,
    double? height,
    double spacing = 0,
  }) => GoogleFonts.manrope(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: size * spacing,
    fontFeatures: _tabular,
  );

  static TextStyle get displayLg => _style(
    size: AppFontSize.display,
    weight: AppFontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.25,
    spacing: -0.015,
  );
  static TextStyle get headingMd => _style(
    size: AppFontSize.xxl,
    weight: AppFontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
    spacing: -0.015,
  );
  static TextStyle get headingSm => _style(
    size: AppFontSize.xl,
    weight: AppFontWeight.semiBold,
    color: AppColors.textPrimary,
    height: 1.27,
    spacing: -0.01,
  );
  static TextStyle get titleMd => _style(
    size: AppFontSize.title,
    weight: AppFontWeight.semiBold,
    color: AppColors.textPrimary,
    height: 1.33,
    spacing: -0.005,
  );
  static TextStyle get titleSm => _style(
    size: AppFontSize.md,
    weight: AppFontWeight.semiBold,
    color: AppColors.textPrimary,
    height: 1.3,
    spacing: 0.01,
  );
  static TextStyle get bodyLg => _style(
    size: AppFontSize.lg,
    weight: AppFontWeight.medium,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  static TextStyle get bodyMd => _style(
    size: AppFontSize.md,
    weight: AppFontWeight.regular,
    color: AppColors.textPrimary,
    height: 1.43,
  );
  static TextStyle get bodySm => _style(
    size: AppFontSize.sm,
    weight: AppFontWeight.regular,
    color: AppColors.textSecondary,
    height: 1.33,
  );
  static TextStyle get labelMd => _style(
    size: AppFontSize.sm,
    weight: AppFontWeight.semiBold,
    color: AppColors.textPrimary,
    height: 1.33,
    spacing: 0.02,
  );
  static TextStyle get labelSm => _style(
    size: AppFontSize.micro,
    weight: AppFontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
    spacing: 0.04,
  );
}

extension AppTextStyleX on TextStyle {
  TextStyle tinted(Color color) => copyWith(color: color);
  TextStyle get bold => copyWith(fontWeight: AppFontWeight.bold);
  TextStyle get semiBold => copyWith(fontWeight: AppFontWeight.semiBold);
  TextStyle get medium => copyWith(fontWeight: AppFontWeight.medium);
  TextStyle get regular => copyWith(fontWeight: AppFontWeight.regular);
  TextStyle sized(double size) => copyWith(fontSize: size);
}
