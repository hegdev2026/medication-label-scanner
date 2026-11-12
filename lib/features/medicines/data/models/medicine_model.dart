import 'package:drift/drift.dart';

import 'package:medicine_lab_reader/core/database/app_database.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';

/// Database representation of a [Medicine].
class MedicineModel extends Medicine {
  const MedicineModel({
    super.id,
    required super.name,
    super.genericName,
    super.strength,
    super.dosageForm,
    super.batchNumber,
    super.manufacturer,
    super.manufacturingDate,
    super.originalManufacturingText,
    super.expiryDate,
    super.originalExpiryText,
    super.imagePath,
    super.rawOcrText,
    super.reviewStatus,
    required super.createdAt,
    required super.updatedAt,
  });

  factory MedicineModel.fromRow(MedicinesTableData r) => MedicineModel(
    id: r.id,
    name: r.medicineName,
    genericName: r.genericName,
    strength: r.strength,
    dosageForm: r.dosageForm,
    batchNumber: r.batchNumber,
    manufacturer: r.manufacturer,
    manufacturingDate: r.manufacturingDate,
    originalManufacturingText: r.originalManufacturingText,
    expiryDate: r.expiryDate,
    originalExpiryText: r.originalExpiryText,
    imagePath: r.imagePath,
    rawOcrText: r.rawOcrText,
    reviewStatus: ReviewStatus.values.firstWhere(
      (s) => s.name == r.reviewStatus,
      orElse: () => ReviewStatus.confirmed,
    ),
    createdAt: r.createdAt,
    updatedAt: r.updatedAt,
  );

  static MedicinesTableCompanion toCompanion(Medicine m) {
    final id = m.id;
    return MedicinesTableCompanion(
      id: id == null ? const Value.absent() : Value(id),
      medicineName: Value(m.name),
      genericName: Value(m.genericName),
      strength: Value(m.strength),
      dosageForm: Value(m.dosageForm),
      batchNumber: Value(m.batchNumber),
      manufacturer: Value(m.manufacturer),
      manufacturingDate: Value(m.manufacturingDate),
      originalManufacturingText: Value(m.originalManufacturingText),
      expiryDate: Value(m.expiryDate),
      originalExpiryText: Value(m.originalExpiryText),
      imagePath: Value(m.imagePath),
      rawOcrText: Value(m.rawOcrText),
      reviewStatus: Value(m.reviewStatus.name),
      createdAt: Value(m.createdAt),
      updatedAt: Value(m.updatedAt),
    );
  }
}
