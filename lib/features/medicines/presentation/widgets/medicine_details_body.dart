import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/adaptive/adaptive_view.dart';
import 'package:medicine_lab_reader/common/adaptive/form_factor.dart';
import 'package:medicine_lab_reader/common/widgets/content_wrapper.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_info_query.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/expiry_batch_card.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/generic_name_card.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/label_notes_card.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_identity_card.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_image_panel.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_info_section.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/ocr_text_card.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/review_status_pill.dart';

class MedicineDetailsBody extends StatelessWidget {
  const MedicineDetailsBody({super.key, required this.medicine});
  final Medicine medicine;

  static Widget _gap(Widget w) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpace.md),
    child: w,
  );

  @override
  Widget build(BuildContext context) {
    final m = medicine;
    final ocr = m.rawOcrText;
    final hasPanel = m.imagePath != null || ocr.isNotEmpty;
    final hasGeneric = (m.genericName ?? '').isNotEmpty;
    final status = Align(
      alignment: Alignment.centerLeft,
      child: ReviewStatusPill(status: m.reviewStatus),
    );
    // Your own data on one side, general information on the other.
    final leftFacts = [
      _gap(MedicineIdentityCard(medicine: m)),
      _gap(ExpiryBatchCard(medicine: m)),
      if (hasGeneric) _gap(GenericNameCard(medicine: m)),
    ];
    final rightFacts = [
      _gap(MedicineInfoSection(query: MedicineInfoQuery.fromMedicine(m))),
      _gap(const LabelNotesCard()),
    ];
    final facts = [...leftFacts, ...rightFacts];
    final wide = context.isDesktopUi;
    return ContentWrapper(
      scrollable: true,
      maxWidth: !hasPanel && wide ? 1200 : 960,
      child: AdaptiveView(
        mobile: (_) => Column(
          children: [
            _gap(status),
            ...facts,
            if (ocr.isNotEmpty) _gap(OcrTextCard(text: ocr)),
          ],
        ),
        // Added by hand or from search: no photo or OCR text, so no left
        // column. Desktop splits the cards into two side-by-side columns; a
        // tablet gets one centred column at a readable width.
        tablet: (_) => !hasPanel
            ? Column(
                children: [
                  _gap(status),
                  wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Column(children: leftFacts)),
                            const SizedBox(width: AppSpace.xl),
                            Expanded(child: Column(children: rightFacts)),
                          ],
                        )
                      : Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 720),
                            child: Column(children: facts),
                          ),
                        ),
                ],
              )
            : Column(
                children: [
                  _gap(status),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: MedicineImagePanel(
                          imagePath: m.imagePath,
                          rawText: ocr,
                        ),
                      ),
                      const SizedBox(width: AppSpace.xl),
                      Expanded(flex: 3, child: Column(children: facts)),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
