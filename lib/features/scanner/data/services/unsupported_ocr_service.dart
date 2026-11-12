import 'package:medicine_lab_reader/features/scanner/domain/entities/ocr_result.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/medicine_ocr_service.dart';

/// Placeholder for desktop platforms until native adapters (Vision on macOS,
/// Windows.Media.Ocr, Tesseract on Linux) are added behind the same interface.
class UnsupportedOcrService implements MedicineOcrService {
  @override
  bool get isAvailable => false;

  @override
  Future<OcrResult> recognizeText(String imagePath) async =>
      const OcrResult(text: '');
}
