import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/utils/added_on.dart';
import 'package:medicine_lab_reader/common/widgets/app_pill.dart';
import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/expiry_pill.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_menu_button.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_thumb.dart';

/// Library card (list view): photo, chips, name, strength • maker, and the
/// scan time with the printed expiry.
class MedicineCard extends StatelessWidget {
  const MedicineCard({
    super.key,
    required this.medicine,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });
  final Medicine medicine;
  final VoidCallback onTap, onEdit, onDelete;

  @override
  Widget build(BuildContext context) {
    final m = medicine;
    final sub = [?m.strength, ?m.manufacturer].join(' • ');
    final chip = m.genericName;
    return AppSurface(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpace.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MedicineThumb(medicine: m),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (m.reviewStatus == ReviewStatus.needsReview)
                            AppPill(
                              label: 'inventory.needsReview'.tr(),
                              tone: AppPillTone.warning,
                              compact: true,
                            ),
                          if (chip != null && chip.isNotEmpty)
                            AppPill(label: chip, compact: true),
                        ],
                      ),
                    ),
                    MedicineMenuButton(onEdit: onEdit, onDelete: onDelete),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  m.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.titleMd,
                ),
                if (sub.isNotEmpty)
                  Text(
                    sub,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySm,
                  ),
                const SizedBox(height: AppSpace.sm),
                Wrap(
                  spacing: AppSpace.sm,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatAddedOn(
                            m.createdAt,
                            DateTime.now(),
                            context.locale.toString(),
                          ),
                          style: AppText.labelMd.regular.tinted(
                            AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    ExpiryPill(medicine: m),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
