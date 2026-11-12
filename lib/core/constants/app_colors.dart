import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/theme/app_palette.dart';

/// The single place colours are resolved. Almost every member is a runtime
/// getter that follows the active palette, so **never** use them inside a
/// `const` expression (only [onAccent] is const-safe).
class AppColors {
  const AppColors._();

  static AppPalette palette = AppPalette.light;
  static bool get isDark => palette.isDark;

  static const Color onAccent = AppPalette.onAccent;

  static Color get background => palette.background;
  static Color get card => palette.card;
  static Color get inset => palette.inset;
  static Color get border => palette.border;
  static Color get textPrimary => palette.textPrimary;
  static Color get textSecondary => palette.textSecondary;
  static Color get textMuted => palette.textMuted;
  static Color get primary => palette.primary;
  static Color get primaryContainer => palette.primaryContainer;
  static Color get onPrimaryContainer => palette.onPrimaryContainer;
  static Color get noticeBg => palette.noticeBg;
  static Color get noticeText => palette.noticeText;
  static Color get shadow => palette.shadow;

  // Mint accent family and the always-dark camera panel.
  static Color get accent => palette.accent;
  static Color get onAccentFill => palette.onAccentFill;
  static Color get accentText => palette.accentText;
  static Color get warningBg => palette.warningBg;
  static Color get warningContainer => palette.warningContainer;
  static Color get warningText => palette.warningText;
  static Color get scanSurface => palette.scanSurface;
  static Color get scanControl => palette.scanControl;
  static Color get hero => palette.hero;
  static Color get heroMuted => palette.heroMuted;

  // Loading skeleton.
  static Color get shimmerBase => palette.shimmerBase;
  static Color get shimmerHighlight => palette.shimmerHighlight;

  // Status ramp.
  static Color get success => palette.success;
  static Color get warning => palette.warning;
  static Color get danger => palette.danger;

  // Expiry semantics.
  static Color get expired => danger;
  static Color get expiringSoon => warning;
  static Color get expiryOk => success;
  static Color get expiryNone => textMuted;
}
