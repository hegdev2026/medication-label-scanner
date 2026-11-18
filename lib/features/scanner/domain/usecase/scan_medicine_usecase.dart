import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/scanner/domain/entities/extracted_details.dart';
import 'package:medicine_lab_reader/features/scanner/domain/entities/ocr_result.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/cloud_ocr_service.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/cloud_scan_settings.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/medicine_ocr_service.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/medicine_parser.dart';

/// Reads a package photo and parses candidate fields. With the user's
/// agreement it first tries the online OCR (smart scan); if that is off or
/// fails, it reads the photo on the device. Returns [OcrUnavailableFailure]
/// when neither is possible.
@lazySingleton
class ScanMedicineUsecase implements UseCase<ScanDraft, String> {
  ScanMedicineUsecase(this._ocr, this._parser, this._cloudOcr, this._cloud);
  final MedicineOcrService _ocr;
  final MedicineParser _parser;
  final CloudOcrService _cloudOcr;
  final CloudScanSettings _cloud;

  Either<Failure, ScanDraft> _draft(String imagePath, OcrResult result) {
    if (result.isEmpty) {
      return Right(
        ScanDraft(
          imagePath: imagePath,
          rawText: '',
          details: const ExtractedDetails(warnings: [ExtractionWarning.noText]),
        ),
      );
    }
    return Right(
      ScanDraft(
        imagePath: imagePath,
        rawText: result.text,
        details: _parser.parse(result.text),
      ),
    );
  }

  @override
  Future<Either<Failure, ScanDraft>> call(String imagePath) async {
    if (_cloud.available && _cloud.consent == true) {
      try {
        final online = await _cloudOcr.recognizeText(imagePath);
        // Empty text from the online service falls through to the device.
        if (!online.isEmpty) return _draft(imagePath, online);
      } catch (_) {
        // Offline, over the quota or too big: read it on the device instead.
      }
    }
    if (!_ocr.isAvailable) return const Left(OcrUnavailableFailure());
    try {
      return _draft(imagePath, await _ocr.recognizeText(imagePath));
    } catch (e) {
      return Left(OcrFailure(detail: '$e'));
    }
  }
}
