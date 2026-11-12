import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

class ScanTipsCard extends StatelessWidget {
  const ScanTipsCard({super.key});

  @override
  Widget build(BuildContext context) => AppSurface(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Icon(
            Icons.tips_and_updates_outlined,
            color: AppColors.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: AppSpace.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('scan.tipsTitle'.tr(), style: AppText.titleMd),
              const SizedBox(height: AppSpace.xs),
              for (final k in const ['scan.tip1', 'scan.tip2', 'scan.tip3'])
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text('• ${k.tr()}', style: AppText.bodySm),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
