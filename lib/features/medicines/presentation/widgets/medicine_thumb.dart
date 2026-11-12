import 'dart:io';

import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/dosage_category.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_image.dart';

/// Package photo with a form tag, or an icon tile when there is no photo.
class MedicineThumb extends StatelessWidget {
  const MedicineThumb({
    super.key,
    required this.medicine,
    this.width = 80,
    this.height = 96,
  });
  final Medicine medicine;
  final double width, height;

  static IconData iconFor(DosageCategory c) => switch (c) {
    DosageCategory.tablet => Icons.medication_outlined,
    DosageCategory.capsule => Icons.medication_liquid_outlined,
    DosageCategory.syrup => Icons.water_drop_outlined,
    DosageCategory.topical => Icons.sanitizer_outlined,
    DosageCategory.other => Icons.medication_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final path = medicine.imagePath;
    final form = medicine.dosageForm?.trim();
    final hasPhoto = path != null && path.isNotEmpty && File(path).existsSync();
    final radius = BorderRadius.circular(AppRadius.xl);
    if (hasPhoto) {
      return SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            MedicineImage(path: path, radius: AppRadius.xl),
            if (form != null && form.isNotEmpty)
              Positioned(
                right: 4,
                bottom: 4,
                child: Container(
                  constraints: BoxConstraints(maxWidth: width - 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.scanSurface.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Text(
                    form,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.labelSm.sized(9).tinted(AppColors.onAccent),
                  ),
                ),
              ),
          ],
        ),
      );
    }
    final category = DosageCategoryResolver.of(form);
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(AppSpace.sm),
      decoration: BoxDecoration(color: AppColors.inset, borderRadius: radius),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: category == DosageCategory.capsule
                  ? AppColors.accent
                  : AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconFor(category),
              size: 22,
              color: category == DosageCategory.capsule
                  ? AppColors.onAccentFill
                  : AppColors.onPrimaryContainer,
            ),
          ),
          if (form != null && form.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              form.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppText.labelSm
                  .sized(9)
                  .tinted(AppColors.textSecondary)
                  .copyWith(letterSpacing: 0.8),
            ),
          ],
        ],
      ),
    );
  }
}
