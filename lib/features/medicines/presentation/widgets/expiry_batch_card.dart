import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/check_expiry.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/details_card_header.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/expiry_badge.dart';

/// Printed expiry (as read), the date it is treated as, manufacture date and
/// batch. Month-only dates are labelled, never silently reinterpreted.
class ExpiryBatchCard extends StatelessWidget {
  const ExpiryBatchCard({super.key, required this.medicine});
  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    final m = medicine;
    final locale = context.locale.toString();
    final expiry = m.expiryDate;
    final status = CheckExpiry.statusFor(expiry, DateTime.now());
    final printed = m.originalExpiryText;
    final batch = m.batchNumber;
    final mfg = m.originalManufacturingText;
    return AppSurface(
      padding: const EdgeInsets.all(AppSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailsCardHeader(
            icon: Icons.calendar_today_outlined,
            title: 'details.batchExpiry'.tr(),
            subtitle: 'details.traceability'.tr(),
            trailing: ExpiryBadge(status: status),
          ),
          const SizedBox(height: AppSpace.md),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _Tile(
                    label: 'form.expiryDate'.tr(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          printed ??
                              (expiry == null
                                  ? '—'
                                  : DateFormat.yMMM(locale).format(expiry)),
                          style: AppText.titleMd.tinted(AppColors.primary),
                        ),
                        if (expiry != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'details.usedAs'.tr(
                                args: [DateFormat.yMMMd(locale).format(expiry)],
                              ),
                              style: AppText.bodySm,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _Tile(
                    label: 'form.mfgDate'.tr(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mfg == null || mfg.isEmpty
                              ? 'common.notRecorded'.tr()
                              : mfg,
                          style: AppText.titleSm,
                        ),
                        const SizedBox(height: AppSpace.sm),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.card.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'form.batch'.tr(),
                                style: AppText.labelSm.regular.tinted(
                                  AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                batch == null || batch.isEmpty ? '—' : batch,
                                style: AppText.labelMd.copyWith(
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpace.md),
    decoration: BoxDecoration(
      color: AppColors.inset,
      borderRadius: BorderRadius.circular(AppRadius.xl),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppText.labelSm.regular
              .sized(11)
              .tinted(AppColors.textSecondary),
        ),
        const SizedBox(height: 2),
        child,
      ],
    ),
  );
}
