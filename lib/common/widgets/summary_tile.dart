import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

/// Compact count tile: icon, number and label side by side. When [onTap] is set
/// it works as a shortcut (e.g. to a filter) and [selected] tints it.
class SummaryTile extends StatelessWidget {
  const SummaryTile({
    super.key,
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
    this.selected = false,
    this.onTap,
  });
  final IconData icon;
  final Color color;
  final int value;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? color.withValues(alpha: 0.12) : AppColors.card,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      side: BorderSide(color: selected ? color : AppColors.border),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.sm + 2,
          vertical: AppSpace.sm,
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$value', style: AppText.titleMd),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.labelSm.regular.tinted(
                      AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
