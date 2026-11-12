import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

/// Dismissible tip. Dismissal lives in the dashboard cubit.
class KnowInsideCard extends StatelessWidget {
  const KnowInsideCard({super.key, required this.onDismiss});
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) => AppSurface(
    kind: AppSurfaceKind.inset,
    padding: const EdgeInsets.all(AppSpace.lg),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Icon(
            Icons.health_and_safety_outlined,
            color: AppColors.accentText,
          ),
        ),
        const SizedBox(width: AppSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('dashboard.tipTitle'.tr(), style: AppText.titleMd),
              const SizedBox(height: 4),
              Text('dashboard.tipBody'.tr(), style: AppText.bodySm),
              const SizedBox(height: AppSpace.sm),
              Row(
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 14,
                    color: AppColors.accentText,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'dashboard.tipFoot'.tr(),
                      style: AppText.labelMd.tinted(AppColors.accentText),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onDismiss,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(Icons.close, size: 18, color: AppColors.textSecondary),
          ),
        ),
      ],
    ),
  );
}
