import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

/// Footer hint that points at the expiry tracker.
class OlderLabelsBanner extends StatelessWidget {
  const OlderLabelsBanner({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppSurface(
    kind: AppSurfaceKind.inset,
    onTap: onTap,
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.event_available_outlined,
            color: AppColors.onAccentFill,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('inventory.footerTitle'.tr(), style: AppText.titleSm),
              const SizedBox(height: 2),
              Text('inventory.footerBody'.tr(), style: AppText.bodySm),
            ],
          ),
        ),
        Icon(Icons.chevron_right, color: AppColors.textSecondary),
      ],
    ),
  );
}
