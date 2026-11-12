import 'package:equatable/equatable.dart';

class Medicine extends Equatable {
  const Medicine({
    this.id,
    required this.name,
    this.genericName,
    this.strength,
    this.dosageForm,
    this.batchNumber,
    this.manufacturer,
    this.manufacturingDate,
    this.originalManufacturingText,
    this.expiryDate,
    this.originalExpiryText,
    this.imagePath,
    this.rawOcrText = '',
    this.reviewStatus = ReviewStatus.confirmed,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String name;
  final String? genericName;
  final String? strength;
  final String? dosageForm;
  final String? batchNumber;
  final String? manufacturer;
  final DateTime? manufacturingDate;
  final String? originalManufacturingText;
  final DateTime? expiryDate;
  final String? originalExpiryText;
  final String? imagePath;
  final String rawOcrText;
  final ReviewStatus reviewStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  Medicine copyWith({
    int? id,
    String? name,
    String? imagePath,
    DateTime? updatedAt,
  }) => Medicine(
    id: id ?? this.id,
    name: name ?? this.name,
    genericName: genericName,
    strength: strength,
    dosageForm: dosageForm,
    batchNumber: batchNumber,
    manufacturer: manufacturer,
    manufacturingDate: manufacturingDate,
    originalManufacturingText: originalManufacturingText,
    expiryDate: expiryDate,
    originalExpiryText: originalExpiryText,
    imagePath: imagePath ?? this.imagePath,
    rawOcrText: rawOcrText,
    reviewStatus: reviewStatus,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    genericName,
    strength,
    dosageForm,
    batchNumber,
    manufacturer,
    manufacturingDate,
    originalManufacturingText,
    expiryDate,
    originalExpiryText,
    imagePath,
    rawOcrText,
    reviewStatus,
    createdAt,
    updatedAt,
  ];
}

enum ReviewStatus { confirmed, needsReview, manual }
