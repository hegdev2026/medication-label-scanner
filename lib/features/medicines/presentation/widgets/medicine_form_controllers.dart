import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_seed.dart';
import 'package:medicine_lab_reader/features/medicines/domain/value_objects/printed_date.dart';
import 'package:medicine_lab_reader/features/scanner/domain/entities/extracted_details.dart';

/// Text controllers for the medicine form, seeded from a saved record or a
/// scan draft. Owned (and disposed) by the form body.
class MedicineFormControllers {
  MedicineFormControllers({
    Medicine? existing,
    ExtractedDetails? details,
    MedicineSeed? seed,
  }) : name = TextEditingController(
         text: existing?.name ?? details?.name ?? seed?.name ?? '',
       ),
       generic = TextEditingController(
         text: existing?.genericName ?? seed?.genericName ?? '',
       ),
       strength = TextEditingController(
         text: existing?.strength ?? details?.strength ?? seed?.strength ?? '',
       ),
       dosageForm = TextEditingController(
         text:
             existing?.dosageForm ??
             details?.dosageForm ??
             seed?.dosageForm ??
             '',
       ),
       batch = TextEditingController(
         text: existing?.batchNumber ?? details?.batchNumber ?? '',
       ),
       maker = TextEditingController(
         text: existing?.manufacturer ?? details?.manufacturer ?? '',
       ),
       mfg = TextEditingController(
         text:
             existing?.originalManufacturingText ??
             details?.manufacturingDate?.original ??
             '',
       ),
       expiry = TextEditingController(
         text:
             existing?.originalExpiryText ??
             details?.expiryDate?.original ??
             '',
       );

  final TextEditingController name,
      generic,
      strength,
      dosageForm,
      batch,
      maker,
      mfg,
      expiry;

  PrintedDate? get mfgDate => PrintedDate.parse(mfg.text);
  PrintedDate? get expiryDate => PrintedDate.parse(expiry.text);

  String? _orNull(TextEditingController c) {
    final t = c.text.trim();
    return t.isEmpty ? null : t;
  }

  Medicine toMedicine({
    Medicine? existing,
    String? imagePath,
    String rawText = '',
    required bool fromScan,
  }) {
    final now = DateTime.now();
    final m = mfgDate, e = expiryDate;
    return Medicine(
      id: existing?.id,
      name: name.text.trim(),
      genericName: _orNull(generic),
      strength: _orNull(strength),
      dosageForm: _orNull(dosageForm),
      batchNumber: _orNull(batch),
      manufacturer: _orNull(maker),
      manufacturingDate: m?.toDateTime(),
      originalManufacturingText: m?.original,
      expiryDate: e?.toDateTime(),
      originalExpiryText: e?.original,
      imagePath: imagePath,
      rawOcrText: rawText,
      reviewStatus: fromScan
          ? ReviewStatus.confirmed
          : (existing?.reviewStatus ?? ReviewStatus.manual),
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
  }

  void dispose() {
    for (final c in [
      name,
      generic,
      strength,
      dosageForm,
      batch,
      maker,
      mfg,
      expiry,
    ]) {
      c.dispose();
    }
  }
}
