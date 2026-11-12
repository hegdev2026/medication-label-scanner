import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/details_card_header.dart';

/// The untouched OCR text, kept for the audit trail.
class OcrTextCard extends StatelessWidget {
  const OcrTextCard({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => AppSurface(
    padding: const EdgeInsets.all(AppSpace.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailsCardHeader(
          icon: Icons.text_snippet_outlined,
          title: 'details.ocrText'.tr(),
          subtitle: 'details.ocrSub'.tr(),
        ),
        const SizedBox(height: AppSpace.md),
        SelectableText(text),
      ],
    ),
  );
}
