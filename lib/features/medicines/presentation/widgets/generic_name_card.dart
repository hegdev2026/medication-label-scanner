import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/details_card_header.dart';

/// Generic name and strength exactly as saved. No ingredient lookup is made.
class GenericNameCard extends StatelessWidget {
  const GenericNameCard({super.key, required this.medicine});
  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    final generic = medicine.genericName;
    final strength = medicine.strength;
    return AppSurface(
      padding: const EdgeInsets.all(AppSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailsCardHeader(
            icon: Icons.science_outlined,
            title: 'details.nameStrength'.tr(),
            subtitle: 'details.fromLabel'.tr(),
          ),
          const SizedBox(height: AppSpace.md),
          Container(
            padding: const EdgeInsets.all(AppSpace.md),
            decoration: BoxDecoration(
              color: AppColors.inset,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(medicine.name, style: AppText.titleSm.bold),
                      Text(
                        generic == null || generic.isEmpty
                            ? 'common.notRecorded'.tr()
                            : generic,
                        style: AppText.bodySm,
                      ),
                    ],
                  ),
                ),
                if (strength != null && strength.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Text(
                      strength,
                      style: AppText.labelMd.bold.tinted(AppColors.primary),
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
