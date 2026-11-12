import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/scanner/domain/entities/extracted_details.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/medicine_ocr_service.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/medicine_parser.dart';

/// Runs OCR on an image and parses candidate fields.
/// Returns [OcrUnavailableFailure] when the platform has no OCR engine.
@lazySingleton
class ScanMedicineUsecase implements UseCase<ScanDraft, String> {
  ScanMedicineUsecase(this._ocr, this._parser);
  final MedicineOcrService _ocr;
  final MedicineParser _parser;

  @override
  Future<Either<Failure, ScanDraft>> call(String imagePath) async {
    if (!_ocr.isAvailable) return const Left(OcrUnavailableFailure());
    try {
      final result = await _ocr.recognizeText(imagePath);
      if (result.isEmpty) {
        return Right(
          ScanDraft(
            imagePath: imagePath,
            rawText: '',
            details: const ExtractedDetails(
              warnings: [ExtractionWarning.noText],
            ),
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
    } catch (e) {
      return Left(OcrFailure(detail: '$e'));
    }
  }
}
