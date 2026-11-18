import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/constants/app_api.dart';
import 'package:medicine_lab_reader/core/network/dio/dio_client.dart';
import 'package:medicine_lab_reader/features/scanner/domain/entities/ocr_result.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/cloud_ocr_service.dart';

/// OCR.space online OCR (free key). Only the photo is sent.
@LazySingleton(as: CloudOcrService)
class OcrSpaceService implements CloudOcrService {
  OcrSpaceService(this._client);
  final DioClient _client;

  /// The free plan accepts files up to 1 MB.
  static const _maxBytes = 1024 * 1024;

  @override
  Future<OcrResult> recognizeText(String imagePath) async {
    final file = File(imagePath);
    if (await file.length() > _maxBytes) {
      throw const FormatException('image too big for the free plan');
    }
    final res = await _client.postForm(
      AppApi.ocrSpaceUrl,
      FormData.fromMap({
        'apikey': AppApi.ocrSpaceKey,
        'language': 'eng',
        'OCREngine': '2',
        'scale': 'true',
        'detectOrientation': 'true',
        'file': await MultipartFile.fromFile(imagePath),
      }),
    );
    return parse(res.data);
  }

  /// Maps OCR.space's JSON answer to text. Throws on an error answer.
  static OcrResult parse(Object? data) {
    if (data is! Map<String, dynamic>) {
      throw const FormatException('unexpected response');
    }
    if (data['IsErroredOnProcessing'] == true) {
      throw FormatException('OCR.space error: ${data['ErrorMessage']}');
    }
    final results = data['ParsedResults'];
    if (results is! List) return const OcrResult(text: '');
    final text = [
      for (final r in results.whereType<Map<String, dynamic>>())
        if (r['ParsedText'] case final String t) t,
    ].join('\n');
    return OcrResult(text: text.trim());
  }
}
