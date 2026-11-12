import 'package:medicine_lab_reader/features/scanner/domain/entities/ocr_result.dart';

/// Domain-facing OCR contract. Implementations live in the data layer so the
/// domain never depends on ML Kit, Vision, Windows OCR or Tesseract.
abstract interface class MedicineOcrService {
  bool get isAvailable;
  Future<OcrResult> recognizeText(String imagePath);
}
