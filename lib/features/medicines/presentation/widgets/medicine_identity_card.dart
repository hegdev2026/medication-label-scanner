import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_pill.dart';
import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_thumb.dart';

/// Hero card: photo, form, name, generic • strength, maker and a 3-up readout.
class MedicineIdentityCard extends StatelessWidget {
  const MedicineIdentityCard({super.key, required this.medicine});
  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    final m = medicine;
    final form = m.dosageForm;
    final sub = [?m.genericName, ?m.strength].join(' • ');
    final maker = m.manufacturer;
    return AppSurface(
      padding: const EdgeInsets.all(AppSpace.lg),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MedicineThumb(medicine: m, width: 96, height: 112),
              const SizedBox(width: AppSpace.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (form != null && form.isNotEmpty)
                      Text(
                        form.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.labelMd
                            .tinted(AppColors.accentText)
                            .copyWith(letterSpacing: 1),
                      ),
                    Text(
                      m.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.titleMd.copyWith(height: 1.2),
                    ),
                    if (sub.isNotEmpty) Text(sub, style: AppText.bodySm),
                    if (maker != null && maker.isNotEmpty) ...[
                      const SizedBox(height: AppSpace.sm),
                      AppPill(
                        label: maker,
                        icon: Icons.storefront_outlined,
                        compact: true,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.lg),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.inset.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Row(
              children: [
                _Readout('form.strength'.tr(), m.strength),
                _Readout('form.dosageForm'.tr(), m.dosageForm),
                _Readout('form.batch'.tr(), m.batchNumber),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Readout extends StatelessWidget {
  const _Readout(this.label, this.value);
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final v = value;
    return Expanded(
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.labelSm.regular.tinted(AppColors.textSecondary),
          ),
          const SizedBox(height: 2),
          Text(
            v == null || v.isEmpty ? '—' : v,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppText.titleSm,
          ),
        ],
      ),
    );
  }
}
