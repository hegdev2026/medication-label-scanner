import 'package:medicine_lab_reader/features/scanner/domain/entities/ocr_result.dart';

/// Reads the text on a photo with an online OCR service. Implementations live
/// in the data layer. Throws when the service cannot be used, so the caller
/// can fall back to reading on the device.
abstract interface class CloudOcrService {
  Future<OcrResult> recognizeText(String imagePath);
}
