import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/shell/presentation/widgets/nav_destinations.dart';

/// Floating pill bar with one evenly spaced tab per destination. The scan
/// button is a separate floating action button owned by the shell.
class MobileBottomNav extends StatelessWidget {
  const MobileBottomNav({
    super.key,
    required this.index,
    required this.onSelected,
  });
  final int index;
  final ValueChanged<int> onSelected;

  Widget _item(int i) {
    final d = navDestinations[i];
    final selected = i == index;
    final color = selected ? AppColors.primary : AppColors.textSecondary;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.full),
        onTap: () => onSelected(i),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44, minWidth: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(selected ? d.selectedIcon : d.icon, size: 22, color: color),
              const SizedBox(height: 2),
              Text(
                d.labelKey.tr(),
                maxLines: 1,
                style: AppText.labelSm
                    .tinted(color)
                    .copyWith(
                      fontWeight: selected
                          ? AppFontWeight.bold
                          : AppFontWeight.medium,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.margin,
        AppSpace.lg,
        AppSpace.margin,
        AppSpace.sm,
      ),
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 448),
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.xs),
            decoration: BoxDecoration(
              color: AppColors.card.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(AppRadius.full),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 32,
                  spreadRadius: -4,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Row(
              children: [
                for (var i = 0; i < navDestinations.length; i++) _item(i),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
