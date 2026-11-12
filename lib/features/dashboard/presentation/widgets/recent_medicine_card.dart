import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/utils/added_on.dart';
import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/check_expiry.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/expiry_badge.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_image.dart';

/// Compact card of the "Recently scanned" carousel. Shows only what was read
/// from the label.
class RecentMedicineCard extends StatelessWidget {
  const RecentMedicineCard({super.key, required this.medicine, this.onTap});
  final Medicine medicine;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final m = medicine;
    final now = DateTime.now();
    final locale = context.locale.toString();
    final status = CheckExpiry.statusFor(m.expiryDate, now);
    final expiry = m.expiryDate;
    final sub = [?m.strength, ?m.dosageForm].join(' • ');
    final detail = m.genericName ?? m.batchNumber;
    final expiryText = expiry == null
        ? 'expiry.none'.tr()
        : 'inventory.expShort'.tr(
            args: [
              m.originalExpiryText ?? DateFormat.yMMM(locale).format(expiry),
            ],
          );
    final color = ExpiryBadge.colorOf(status);
    return AppSurface(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MedicineImage(path: m.imagePath, size: 56, radius: AppRadius.xl),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpiryBadge(status: status),
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.inset,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        m.manufacturer ?? 'common.notRecorded'.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.labelMd.regular.tinted(
                          AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpace.sm),
                    Text(
                      formatAddedOn(m.createdAt, now, locale),
                      style: AppText.labelMd.regular.tinted(
                        AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (detail != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    detail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySm.tinted(AppColors.textPrimary),
                  ),
                ],
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  expiryText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.labelMd.tinted(color),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
