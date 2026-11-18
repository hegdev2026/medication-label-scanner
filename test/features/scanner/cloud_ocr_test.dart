import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:medicine_lab_reader/features/scanner/data/services/ocr_space_service.dart';
import 'package:medicine_lab_reader/features/scanner/domain/entities/ocr_result.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/cloud_ocr_service.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/cloud_scan_settings.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/medicine_ocr_service.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/medicine_parser.dart';
import 'package:medicine_lab_reader/features/scanner/domain/usecase/scan_medicine_usecase.dart';

class _Ocr extends Mock implements MedicineOcrService {}

class _Cloud extends Mock implements CloudOcrService {}

class _Settings extends Mock implements CloudScanSettings {}

void main() {
  group('OcrSpaceService.parse', () {
    test('joins the parsed text of every result', () {
      final r = OcrSpaceService.parse({
        'IsErroredOnProcessing': false,
        'ParsedResults': [
          {'ParsedText': 'DOLO 650\r\nEXP 02/2028'},
        ],
      });
      expect(r.text, contains('DOLO 650'));
      expect(r.isEmpty, isFalse);
    });

    test('an error answer throws so the device reader takes over', () {
      expect(
        () => OcrSpaceService.parse({
          'IsErroredOnProcessing': true,
          'ErrorMessage': ['File size exceeds limit'],
        }),
        throwsFormatException,
      );
    });

    test('no results is empty text, not an error', () {
      expect(OcrSpaceService.parse({'ParsedResults': null}).isEmpty, isTrue);
    });
  });

  group('ScanMedicineUsecase with online OCR', () {
    late _Ocr device;
    late _Cloud cloud;
    late _Settings settings;
    late ScanMedicineUsecase usecase;

    setUp(() {
      device = _Ocr();
      cloud = _Cloud();
      settings = _Settings();
      when(() => device.isAvailable).thenReturn(true);
      when(
        () => device.recognizeText(any()),
      ).thenAnswer((_) async => const OcrResult(text: 'On device text'));
      when(() => settings.available).thenReturn(true);
      usecase = ScanMedicineUsecase(device, MedicineParser(), cloud, settings);
    });

    test('uses the online text when the user agreed', () async {
      when(() => settings.consent).thenReturn(true);
      when(() => cloud.recognizeText(any())).thenAnswer(
        (_) async => const OcrResult(text: 'DOLO 650\nEXP: 02/2028'),
      );
      final d = (await usecase('p.jpg')).getOrElse(() => throw 'fail');
      expect(d.details.expiryDate?.original, '02/2028');
      verifyNever(() => device.recognizeText(any()));
    });

    test('never sends a photo before the user has been asked', () async {
      when(() => settings.consent).thenReturn(null);
      await usecase('p.jpg');
      verifyNever(() => cloud.recognizeText(any()));
    });

    test('never sends a photo after the user said no', () async {
      when(() => settings.consent).thenReturn(false);
      await usecase('p.jpg');
      verifyNever(() => cloud.recognizeText(any()));
    });

    test('falls back to the device when the online reader fails', () async {
      when(() => settings.consent).thenReturn(true);
      when(() => cloud.recognizeText(any())).thenThrow(Exception('quota'));
      final d = (await usecase('p.jpg')).getOrElse(() => throw 'fail');
      expect(d.rawText, 'On device text');
    });

    test(
      'falls back to the device when the online reader finds no text',
      () async {
        when(() => settings.consent).thenReturn(true);
        when(
          () => cloud.recognizeText(any()),
        ).thenAnswer((_) async => const OcrResult(text: ''));
        final d = (await usecase('p.jpg')).getOrElse(() => throw 'fail');
        expect(d.rawText, 'On device text');
      },
    );
  });
}
