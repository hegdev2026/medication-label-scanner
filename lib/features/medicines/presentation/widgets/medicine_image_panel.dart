import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/section_card.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_image.dart';

/// The package photo, with the original OCR text underneath when present.
class MedicineImagePanel extends StatelessWidget {
  const MedicineImagePanel({
    super.key,
    required this.imagePath,
    this.rawText = '',
  });
  final String? imagePath;
  final String rawText;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (imagePath != null)
        Container(
          height: 240,
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpace.sm),
          decoration: BoxDecoration(
            color: AppColors.inset,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: MedicineImage(path: imagePath, fit: BoxFit.contain),
        ),
      if (rawText.isNotEmpty) ...[
        const SizedBox(height: AppSpace.md),
        SectionCard(
          title: 'details.ocrText'.tr(),
          child: SelectableText(rawText),
        ),
      ],
    ],
  );
}
