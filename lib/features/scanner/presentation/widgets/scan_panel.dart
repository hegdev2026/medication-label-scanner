import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/scanner/presentation/widgets/scan_controls.dart';
import 'package:medicine_lab_reader/features/scanner/presentation/widgets/scan_viewfinder.dart';

/// The always-dark capture panel.
class ScanPanel extends StatelessWidget {
  const ScanPanel({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(
      AppSpace.margin,
      AppSpace.lg,
      AppSpace.margin,
      AppSpace.xl,
    ),
    decoration: BoxDecoration(
      color: AppColors.scanSurface,
      borderRadius: BorderRadius.circular(AppRadius.sheet + 8),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 40,
          offset: const Offset(0, 20),
        ),
      ],
    ),
    child: Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Tooltip(
            message: 'common.close'.tr(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => context.pop(),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.scanControl.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, size: 22, color: AppColors.onAccent),
              ),
            ),
          ),
        ),
        Text(
          'scan.panelTitle'.tr(),
          textAlign: TextAlign.center,
          style: AppText.titleMd.tinted(AppColors.onAccent),
        ),
        const SizedBox(height: 2),
        Text(
          'scan.panelSub'.tr(),
          textAlign: TextAlign.center,
          style: AppText.bodySm.tinted(AppColors.heroMuted),
        ),
        const SizedBox(height: AppSpace.lg),
        const ScanViewfinder(),
        const SizedBox(height: AppSpace.lg),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpace.lg,
            vertical: AppSpace.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.scanControl.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(
              color: AppColors.onAccent.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lightbulb_outline, size: 16, color: AppColors.accent),
              const SizedBox(width: AppSpace.sm),
              Flexible(
                child: Text(
                  'scan.guidance'.tr(),
                  style: AppText.bodySm.medium.tinted(AppColors.onAccent),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.xl),
        const ScanControls(),
      ],
    ),
  );
}
