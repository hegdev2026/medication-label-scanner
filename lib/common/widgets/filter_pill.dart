import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_pill.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

/// A filter chip with a live count, used in a horizontally scrolling row.
class FilterPill extends StatelessWidget {
  const FilterPill({
    super.key,
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
    this.showDot = false,
    this.dotColor,
  });
  final String label;
  final int count;
  final bool selected;
  final bool showDot;
  final Color? dotColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected
        ? (AppColors.isDark ? AppColors.onAccentFill : AppColors.onAccent)
        : AppColors.textSecondary;
    return Material(
      color: selected ? AppColors.primary : AppColors.card,
      borderRadius: BorderRadius.circular(AppRadius.full),
      elevation: selected ? 1 : 0.5,
      shadowColor: AppColors.shadow,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.full),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showDot) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: dotColor ?? AppColors.warning,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(label, style: AppText.labelMd.tinted(fg)),
              const SizedBox(width: 6),
              if (selected)
                AppPill(label: '$count', tone: AppPillTone.mint, compact: true)
              else
                Text(
                  '$count',
                  style: AppText.labelSm.tinted(
                    AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
