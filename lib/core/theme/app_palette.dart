import 'package:flutter/material.dart';

/// Two flat value sets, light and dark. Call sites never read these directly:
/// they go through `AppColors`, which picks the live palette.
@immutable
class AppPalette {
  const AppPalette({
    required this.isDark,
    required this.background,
    required this.card,
    required this.inset,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.primary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.success,
    required this.warning,
    required this.danger,
    required this.noticeBg,
    required this.noticeText,
    required this.shadow,
    required this.accent,
    required this.onAccentFill,
    required this.accentText,
    required this.warningBg,
    required this.warningContainer,
    required this.warningText,
    required this.scanSurface,
    required this.scanControl,
    required this.hero,
    required this.heroMuted,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  final bool isDark;
  final Color background;
  final Color card;
  final Color inset;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color primary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color success;
  final Color warning;
  final Color danger;
  final Color noticeBg;
  final Color noticeText;
  final Color shadow;

  /// Bright mint used for scan highlights and hero buttons.
  final Color accent;
  final Color onAccentFill;

  /// Mint-family colour that stays readable as text on [card].
  final Color accentText;
  final Color warningBg;
  final Color warningContainer;
  final Color warningText;

  /// The always-dark camera panel and the controls on it.
  final Color scanSurface;
  final Color scanControl;

  /// Deep-green hero card and the secondary text on it.
  final Color hero;
  final Color heroMuted;

  /// Loading skeleton: the grey bones and the light band sweeping over them.
  final Color shimmerBase;
  final Color shimmerHighlight;

  /// Theme-invariant.
  static const Color onAccent = Color(0xFFFFFFFF);

  static const AppPalette light = AppPalette(
    isDark: false,
    background: Color(0xFFF3F8FF),
    card: Color(0xFFFFFFFF),
    inset: Color(0xFFEAF2FD),
    border: Color(0xFFDCE6F5),
    textPrimary: Color(0xFF0F1B2D),
    textSecondary: Color(0xFF3F4B5F),
    textMuted: Color(0xFF5B6A80),
    primary: Color(0xFF1A4FBF),
    primaryContainer: Color(0xFFDCE8FF),
    onPrimaryContainer: Color(0xFF12327A),
    success: Color(0xFF1F7A58),
    warning: Color(0xFFB9770E),
    danger: Color(0xFFBA1A1A),
    noticeBg: Color(0xFFE3EDFD),
    noticeText: Color(0xFF17356E),
    shadow: Color(0x141A4FBF),
    accent: Color(0xFF9CCBFF),
    onAccentFill: Color(0xFF001A3D),
    accentText: Color(0xFF1546A8),
    warningBg: Color(0xFFFFF9ED),
    warningContainer: Color(0xFFFDEBD0),
    warningText: Color(0xFF784212),
    scanSurface: Color(0xFF0A1530),
    scanControl: Color(0xFF1A2A4D),
    hero: Color(0xFF1A3FA0),
    heroMuted: Color(0xFFA9C4F2),
    shimmerBase: Color(0xFFDCE6F5),
    shimmerHighlight: Color(0xFFF5F9FF),
  );

  static const AppPalette dark = AppPalette(
    isDark: true,
    background: Color(0xFF0B1220),
    card: Color(0xFF131D31),
    inset: Color(0xFF1B2842),
    border: Color(0xFF2A3A5A),
    textPrimary: Color(0xFFE3EAF7),
    textSecondary: Color(0xFFB9C5DB),
    textMuted: Color(0xFF8D9CB8),
    primary: Color(0xFF9CCBFF),
    primaryContainer: Color(0xFF1E3A78),
    onPrimaryContainer: Color(0xFFC9DDFF),
    success: Color(0xFF6ADBAA),
    warning: Color(0xFFFFB74D),
    danger: Color(0xFFFFB4AB),
    noticeBg: Color(0xFF1B2C4D),
    noticeText: Color(0xFFCFDDF5),
    shadow: Color(0x66000000),
    accent: Color(0xFF9CCBFF),
    onAccentFill: Color(0xFF001A3D),
    accentText: Color(0xFF9CCBFF),
    warningBg: Color(0xFF2B2314),
    warningContainer: Color(0xFF3D3016),
    warningText: Color(0xFFF3D9AE),
    scanSurface: Color(0xFF0A1530),
    scanControl: Color(0xFF1A2A4D),
    hero: Color(0xFF1E3A78),
    heroMuted: Color(0xFFA9C4F2),
    shimmerBase: Color(0xFF24324F),
    shimmerHighlight: Color(0xFF384B73),
  );
}
