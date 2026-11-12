import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/adaptive/adaptive_view.dart';
import 'package:medicine_lab_reader/common/widgets/content_wrapper.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/expiry_batch_card.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/generic_name_card.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/label_notes_card.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_identity_card.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_image_panel.dart';
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
    final hasGeneric = (m.genericName ?? '').isNotEmpty;
    final status = Align(
      alignment: Alignment.centerLeft,
      child: ReviewStatusPill(status: m.reviewStatus),
    );
    final facts = [
      _gap(MedicineIdentityCard(medicine: m)),
      _gap(ExpiryBatchCard(medicine: m)),
      if (hasGeneric) _gap(GenericNameCard(medicine: m)),
      _gap(const LabelNotesCard()),
    ];
    return ContentWrapper(
      scrollable: true,
      maxWidth: 960,
      child: AdaptiveView(
        mobile: (_) => Column(
          children: [
            _gap(status),
            ...facts,
            if (ocr.isNotEmpty) _gap(OcrTextCard(text: ocr)),
          ],
        ),
        tablet: (_) => Column(
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
