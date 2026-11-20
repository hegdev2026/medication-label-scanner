import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_lab_reader/features/scanner/domain/entities/extracted_details.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/medicine_parser.dart';

void main() {
  final parser = MedicineParser();

  test('single-line label', () {
    final r = parser.parse(
      'PARACETAMOL TABLETS IP 650 MG BATCH NO: AB123 MFG: 05/2025 EXP: 04/2027',
    );
    expect(r.name, 'Paracetamol');
    expect(r.strength, '650 MG');
    expect(r.dosageForm, 'Tablets');
    expect(r.batchNumber, 'AB123');
    expect(r.manufacturingDate?.month, 5);
    expect(r.expiryDate?.original, '04/2027');
    expect(r.expiryDate?.isMonthOnly, isTrue);
    expect(r.expiryDate?.ambiguous, isFalse);
  });

  test('multi-line label with manufacturer', () {
    final r = parser.parse('''
Amoxicillin Capsules IP
500 mg
B.No. XY9981
Mfg. Date: 11/2024
Exp. Date: 10/2026
Manufactured by:
Acme Pharma Ltd
MRP Rs. 120.00
''');
    expect(r.name, 'Amoxicillin');
    expect(r.strength, '500 MG');
    expect(r.batchNumber, 'XY9981');
    expect(r.expiryDate?.year, 2026);
    expect(r.manufacturer, 'Acme Pharma Ltd');
  });

  test('two-digit year is flagged, missing expiry is not invented', () {
    final a = parser.parse('Test Drug 10 mg EXP 04/27');
    expect(a.expiryDate?.ambiguous, isTrue);
    expect(a.flagged, contains(MedicineField.expiryDate));

    final b = parser.parse('Test Drug 10 mg BATCH: Q1W2');
    expect(b.expiryDate, isNull);
    expect(b.flagged, contains(MedicineField.expiryDate));
  });

  test('price is not treated as strength', () {
    expect(parser.parse('MRP Rs 50 G').strength, isNull);
  });

  test('common misreads of the expiry label still find the date', () {
    expect(parser.parse('Test Drug 10 mg EXR 04/2027').expiryDate?.year, 2027);
    expect(
      parser.parse('Test Drug 10 mg FXP. DATE: 04/2027').expiryDate?.year,
      2027,
    );
    expect(
      parser.parse('Test Drug 10 mg Best before 04/2027').expiryDate?.year,
      2027,
    );
  });
}
