import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_pill.dart';
import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/details_card_header.dart';

/// Amber "please note" card: reminders about reading the label, not medical
/// advice about the product.
class LabelNotesCard extends StatelessWidget {
  const LabelNotesCard({super.key});

  @override
  Widget build(BuildContext context) => AppSurface(
    kind: AppSurfaceKind.tinted,
    fill: AppColors.warningBg,
    padding: const EdgeInsets.all(AppSpace.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailsCardHeader(
          icon: Icons.warning_amber_outlined,
          title: 'details.notesTitle'.tr(),
          iconBg: AppColors.warningContainer,
          iconFg: AppColors.warning,
          titleColor: AppColors.warningText,
          trailing: AppPill(
            label: 'details.notesBadge'.tr(),
            tone: AppPillTone.warning,
            compact: true,
          ),
        ),
        const SizedBox(height: AppSpace.md),
        for (final (icon, key) in const [
          (Icons.fact_check_outlined, 'details.note1'),
          (Icons.event_outlined, 'details.monthNote'),
          (Icons.info_outline, 'details.note3'),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 18, color: AppColors.warning),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    key.tr(),
                    style: AppText.bodyMd.tinted(AppColors.warningText),
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}
