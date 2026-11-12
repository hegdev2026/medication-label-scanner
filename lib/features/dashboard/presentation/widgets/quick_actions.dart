import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({
    super.key,
    required this.onScan,
    required this.onImport,
    required this.onLibrary,
  });
  final VoidCallback onScan, onImport, onLibrary;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'dashboard.quickActions'.tr().toUpperCase(),
        style: AppText.labelMd
            .tinted(AppColors.textSecondary)
            .copyWith(letterSpacing: 1.2),
      ),
      const SizedBox(height: AppSpace.sm),
      Row(
        children: [
          Expanded(
            child: _Action(
              icon: Icons.camera_outlined,
              bg: AppColors.accent,
              fg: AppColors.onAccentFill,
              title: 'dashboard.qaScan'.tr(),
              subtitle: 'dashboard.qaScanSub'.tr(),
              onTap: onScan,
            ),
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: _Action(
              icon: Icons.add_photo_alternate_outlined,
              bg: AppColors.inset,
              fg: AppColors.primary,
              title: 'dashboard.qaImport'.tr(),
              subtitle: 'dashboard.qaImportSub'.tr(),
              onTap: onImport,
            ),
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: _Action(
              icon: Icons.local_pharmacy_outlined,
              bg: AppColors.primaryContainer,
              fg: AppColors.onPrimaryContainer,
              title: 'dashboard.qaLibrary'.tr(),
              subtitle: 'dashboard.qaLibrarySub'.tr(),
              onTap: onLibrary,
            ),
          ),
        ],
      ),
    ],
  );
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.bg,
    required this.fg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final Color bg, fg;
  final String title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppSurface(
    onTap: onTap,
    radius: AppRadius.xl + AppRadius.sm,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpace.sm,
      vertical: AppSpace.md,
    ),
    child: Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Icon(icon, color: fg),
        ),
        const SizedBox(height: AppSpace.sm),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.labelMd.semiBold,
        ),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.labelSm.regular.tinted(AppColors.textSecondary),
        ),
      ],
    ),
  );
}
