import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/dosage_category.dart';

void main() {
  DosageCategory of(String? s) => DosageCategoryResolver.of(s);

  test('classifies common printed forms', () {
    expect(of('Oral Tablet'), DosageCategory.tablet);
    expect(of('film-coated tabs'), DosageCategory.tablet);
    expect(of('20 Hard Capsules'), DosageCategory.capsule);
    expect(of('Syrup'), DosageCategory.syrup);
    expect(of('Oral suspension'), DosageCategory.syrup);
    expect(of('Cream'), DosageCategory.topical);
    expect(of('Gel'), DosageCategory.topical);
  });

  test('softgels and liquid gels are capsules, not topical gels', () {
    expect(of('Liquid Gel'), DosageCategory.capsule);
    expect(of('Softgels'), DosageCategory.capsule);
  });

  test('unknown or empty forms are other, never guessed', () {
    expect(of(null), DosageCategory.other);
    expect(of('  '), DosageCategory.other);
    expect(of('Powder'), DosageCategory.other);
    expect(of('Stable'), DosageCategory.other);
  });
}
