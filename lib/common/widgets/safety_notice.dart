import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

class SafetyNotice extends StatelessWidget {
  const SafetyNotice({super.key});

  @override
  Widget build(BuildContext context) => AppSurface(
    kind: AppSurfaceKind.tinted,
    fill: AppColors.noticeBg,
    padding: const EdgeInsets.all(AppSpace.md),
    radius: AppRadius.lg,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, color: AppColors.noticeText),
        const SizedBox(width: AppSpace.sm),
        Expanded(
          child: Text(
            'safety.notice'.tr(),
            style: AppText.bodyMd.tinted(AppColors.noticeText),
          ),
        ),
      ],
    ),
  );
}
