import 'dart:io';

import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/features/scanner/domain/services/medicine_ocr_service.dart';
import 'package:medicine_lab_reader/features/scanner/data/services/mlkit_ocr_service.dart';
import 'package:medicine_lab_reader/features/scanner/data/services/unsupported_ocr_service.dart';

/// Chooses the OCR engine per platform. Add new platform adapters here.
@module
abstract class OcrModule {
  @lazySingleton
  MedicineOcrService ocr() => (Platform.isAndroid || Platform.isIOS)
      ? MlKitOcrService()
      : UnsupportedOcrService();
}
