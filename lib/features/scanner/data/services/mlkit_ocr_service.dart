import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:medicine_lab_reader/features/scanner/domain/entities/ocr_result.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/medicine_ocr_service.dart';

/// Android / iOS implementation using Google ML Kit (on-device).
class MlKitOcrService implements MedicineOcrService {
  @override
  bool get isAvailable => true;

  @override
  Future<OcrResult> recognizeText(String imagePath) async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final r = await recognizer.processImage(
        InputImage.fromFilePath(imagePath),
      );
      return OcrResult(
        text: r.text,
        blocks: [
          for (final b in r.blocks)
            OcrBlock(
              text: b.text,
              left: b.boundingBox.left,
              top: b.boundingBox.top,
              right: b.boundingBox.right,
              bottom: b.boundingBox.bottom,
            ),
        ],
      );
    } finally {
      await recognizer.close();
    }
  }
}
