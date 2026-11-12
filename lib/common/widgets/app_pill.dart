import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

enum AppPillTone { neutral, verified, mint, warning, danger, success }

/// Capsule telemetry chip (design "Chips & Micro-Pills").
class AppPill extends StatelessWidget {
  const AppPill({
    super.key,
    required this.label,
    this.tone = AppPillTone.neutral,
    this.icon,
    this.dot = false,
    this.compact = false,
  });

  final String label;
  final AppPillTone tone;
  final IconData? icon;

  /// Leading mint dot (the "verified" marker).
  final bool dot;
  final bool compact;

  ({Color bg, Color fg, Color? border}) get _colors => switch (tone) {
    AppPillTone.neutral => (
      bg: AppColors.inset,
      fg: AppColors.textSecondary,
      border: null,
    ),
    AppPillTone.verified => (
      bg: AppColors.primaryContainer,
      fg: AppColors.onPrimaryContainer,
      border: null,
    ),
    AppPillTone.mint => (
      bg: AppColors.accent,
      fg: AppColors.onAccentFill,
      border: null,
    ),
    AppPillTone.warning => (
      bg: AppColors.warningBg,
      fg: AppColors.warning,
      border: AppColors.warning.withValues(alpha: 0.35),
    ),
    AppPillTone.danger => (
      bg: AppColors.danger.withValues(alpha: 0.12),
      fg: AppColors.danger,
      border: null,
    ),
    AppPillTone.success => (
      bg: AppColors.success.withValues(alpha: 0.14),
      fg: AppColors.success,
      border: null,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final c = _colors;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: c.border == null ? null : Border.all(color: c.border ?? c.bg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.accentText,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ] else if (icon != null) ...[
            Icon(icon, size: 13, color: c.fg),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.labelSm.tinted(c.fg),
            ),
          ),
        ],
      ),
    );
  }
}
