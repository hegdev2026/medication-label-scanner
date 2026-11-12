import 'package:equatable/equatable.dart';

import 'package:medicine_lab_reader/features/medicines/domain/value_objects/printed_date.dart';

/// Review notes shown to the user. [key] is a translation key.
enum ExtractionWarning {
  noText('warning.noText'),
  ocrUnavailable('warning.ocrUnavailable'),
  noExpiry('warning.noExpiry'),
  ambiguousExpiry('warning.ambiguousExpiry'),
  multipleStrengths('warning.multipleStrengths'),
  multipleNames('warning.multipleNames'),
  noName('warning.noName');

  const ExtractionWarning(this.key);
  final String key;
}

enum MedicineField {
  name,
  strength,
  dosageForm,
  batch,
  manufacturer,
  mfgDate,
  expiryDate,
}

/// Candidate values parsed from OCR text. Never guessed: missing stays null.
class ExtractedDetails extends Equatable {
  const ExtractedDetails({
    this.name,
    this.nameCandidates = const [],
    this.strength,
    this.strengthCandidates = const [],
    this.dosageForm,
    this.batchNumber,
    this.manufacturer,
    this.manufacturingDate,
    this.expiryDate,
    this.flagged = const {},
    this.warnings = const [],
  });

  const ExtractedDetails.empty() : this();

  final String? name;
  final List<String> nameCandidates;
  final String? strength;
  final List<String> strengthCandidates;
  final String? dosageForm;
  final String? batchNumber;
  final String? manufacturer;
  final PrintedDate? manufacturingDate;
  final PrintedDate? expiryDate;

  /// Fields that are missing or uncertain and need the user's attention.
  final Set<MedicineField> flagged;
  final List<ExtractionWarning> warnings;

  @override
  List<Object?> get props => [
    name,
    nameCandidates,
    strength,
    strengthCandidates,
    dosageForm,
    batchNumber,
    manufacturer,
    manufacturingDate,
    expiryDate,
    flagged,
    warnings,
  ];
}

/// Everything the review screen needs after a scan.
class ScanDraft extends Equatable {
  const ScanDraft({
    required this.imagePath,
    required this.rawText,
    required this.details,
  });
  final String imagePath;
  final String rawText;
  final ExtractedDetails details;
  @override
  List<Object?> get props => [imagePath, rawText, details];
}
