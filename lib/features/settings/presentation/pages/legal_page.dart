import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/content_wrapper.dart';
import 'package:medicine_lab_reader/common/widgets/section_card.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/settings/domain/entities/legal_document.dart';
import 'package:medicine_lab_reader/features/settings/domain/services/legal_documents.dart';

/// Shows one [LegalDocument]: its intro, the last-updated date and each
/// section as a card.
class LegalPage extends StatelessWidget {
  const LegalPage({super.key, required this.document});
  final LegalDocument document;

  @override
  Widget build(BuildContext context) {
    final updated = DateFormat.yMMMMd(
      context.locale.toString(),
    ).format(LegalDocuments.lastUpdated);
    return Scaffold(
      appBar: AppBar(title: Text(document.titleKey.tr())),
      body: ContentWrapper(
        scrollable: true,
        maxWidth: 720,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(document.introKey.tr(), style: AppText.bodyMd),
            const SizedBox(height: AppSpace.xs),
            Text(
              'legal.updated'.tr(args: [updated]),
              style: AppText.labelMd.regular.tinted(AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpace.md),
            for (final s in document.sections) ...[
              SectionCard(
                title: s.titleKey.tr(),
                child: Text(
                  s.bodyKey.tr(),
                  style: AppText.bodyMd.tinted(AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: AppSpace.sm),
            ],
          ],
        ),
      ),
    );
  }
}
