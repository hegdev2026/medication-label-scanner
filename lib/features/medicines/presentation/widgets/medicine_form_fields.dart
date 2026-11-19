import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/adaptive/form_factor.dart';
import 'package:medicine_lab_reader/common/widgets/app_text_field.dart';
import 'package:medicine_lab_reader/common/widgets/section_card.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/date_input_field.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/form_hint_chips.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_form_controllers.dart';
import 'package:medicine_lab_reader/features/scanner/domain/entities/extracted_details.dart';

class MedicineFormFields extends StatelessWidget {
  const MedicineFormFields({
    super.key,
    required this.formKey,
    required this.controllers,
    this.flagged = const {},
    this.warnings = const [],
    this.nameCandidates = const [],
    this.sideBySide = false,
  });

  final GlobalKey<FormState> formKey;
  final MedicineFormControllers controllers;
  final Set<MedicineField> flagged;
  final List<ExtractionWarning> warnings;
  final List<String> nameCandidates;

  /// Desktop with no photo beside the form: lay the two cards out as columns.
  final bool sideBySide;

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: AppSpace.md);
    // Inside side-by-side cards each card is narrow, so its fields stack.
    final twoCol = !sideBySide && (context.isTabletUi || context.isDesktopUi);
    Widget pair(Widget a, Widget b) => twoCol
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: a),
              const SizedBox(width: AppSpace.md),
              Expanded(child: b),
            ],
          )
        : Column(children: [a, gap, b]);
    final c = controllers;

    final detailsCard = SectionCard(
      title: 'form.sectionDetails'.tr(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            controller: c.name,
            icon: Icons.medication_outlined,
            label: '${'form.name'.tr()} *',
            needsReview: flagged.contains(MedicineField.name),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'form.nameRequired'.tr()
                : null,
          ),
          if (nameCandidates.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: AppSpace.sm),
              child: Wrap(
                spacing: AppSpace.sm,
                children: [
                  for (final n in nameCandidates)
                    ActionChip(
                      label: Text(n),
                      onPressed: () => c.name.text = n,
                    ),
                ],
              ),
            ),
          gap,
          pair(
            AppTextField(
              controller: c.strength,
              icon: Icons.science_outlined,
              label: 'form.strength'.tr(),
              needsReview: flagged.contains(MedicineField.strength),
            ),
            AppTextField(
              controller: c.dosageForm,
              icon: Icons.category_outlined,
              label: 'form.dosageForm'.tr(),
            ),
          ),
          FormHintChips(controllers: c),
          gap,
          AppTextField(
            controller: c.generic,
            icon: Icons.biotech_outlined,
            label: 'form.generic'.tr(),
          ),
        ],
      ),
    );
    final batchCard = SectionCard(
      title: 'form.sectionBatch'.tr(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pair(
            AppTextField(
              controller: c.batch,
              icon: Icons.tag,
              label: 'form.batch'.tr(),
              needsReview: flagged.contains(MedicineField.batch),
            ),
            AppTextField(
              controller: c.maker,
              icon: Icons.factory_outlined,
              label: 'form.manufacturer'.tr(),
              needsReview: flagged.contains(MedicineField.manufacturer),
            ),
          ),
          gap,
          pair(
            DateInputField(
              controller: c.mfg,
              label: 'form.mfgDate'.tr(),
              needsReview: flagged.contains(MedicineField.mfgDate),
            ),
            DateInputField(
              controller: c.expiry,
              label: 'form.expiryDate'.tr(),
              needsReview: flagged.contains(MedicineField.expiryDate),
            ),
          ),
        ],
      ),
    );

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (warnings.isNotEmpty) ...[
            SectionCard(
              title: 'form.pleaseReview'.tr(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final w in warnings)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpace.xs),
                      child: Text('• ${w.key.tr()}'),
                    ),
                ],
              ),
            ),
            gap,
          ],
          if (sideBySide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: detailsCard),
                const SizedBox(width: AppSpace.lg),
                Expanded(child: batchCard),
              ],
            )
          else ...[
            detailsCard,
            gap,
            batchCard,
          ],
        ],
      ),
    );
  }
}
