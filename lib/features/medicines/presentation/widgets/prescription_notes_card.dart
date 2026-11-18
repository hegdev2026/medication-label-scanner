import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_pill.dart';
import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/details_card_header.dart';

/// Shown under every medicine: a doctor's prescription comes first, then a
/// few plain-language reminders.
class PrescriptionNotesCard extends StatelessWidget {
  const PrescriptionNotesCard({super.key});

  static const _notes = [
    (Icons.local_pharmacy_outlined, 'notes.pharmacist'),
    (Icons.menu_book_outlined, 'notes.leaflet'),
    (Icons.event_busy_outlined, 'notes.expired'),
    (Icons.child_care_outlined, 'notes.keep'),
    (Icons.emergency_outlined, 'notes.emergency'),
  ];

  @override
  Widget build(BuildContext context) => AppSurface(
    kind: AppSurfaceKind.tinted,
    fill: AppColors.warningBg,
    padding: const EdgeInsets.all(AppSpace.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailsCardHeader(
          icon: Icons.medical_services_outlined,
          title: 'notes.title'.tr(),
          iconBg: AppColors.warningContainer,
          iconFg: AppColors.warning,
          titleColor: AppColors.warningText,
          trailing: AppPill(
            label: 'notes.badge'.tr(),
            tone: AppPillTone.warning,
            compact: true,
          ),
        ),
        const SizedBox(height: AppSpace.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpace.md),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.warning),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.assignment_outlined, color: AppColors.warning),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'notes.rx'.tr(),
                  style: AppText.bodyMd.bold.tinted(AppColors.warningText),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.md),
        for (final (icon, key) in _notes)
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
