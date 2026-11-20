import 'package:flutter_test/flutter_test.dart';

import 'package:medicine_lab_reader/core/services/orientation_policy.dart';
import 'package:medicine_lab_reader/features/settings/presentation/bloc/language_cubit.dart';
import 'package:flutter/painting.dart';

void main() {
  test(
    'shows the choice at once and applies the language after it settles',
    () async {
      final c = LanguageCubit()..settle = const Duration(milliseconds: 20);
      addTearDown(c.close);
      var applied = 0;
      final done = c.select('hi', () async => applied++);
      expect(c.state.code, 'hi');
      expect(applied, 0);
      await done;
      expect(applied, 1);
      await c.select('hi', () async => applied++); // already chosen: no-op
      expect(applied, 1);
    },
  );

  test('phones are below 600 logical pixels, tablets are not', () {
    expect(OrientationPolicy.isPhone(const Size(1080, 2400), 2.75), isTrue);
    expect(OrientationPolicy.isPhone(const Size(1600, 2560), 2.0), isFalse);
  });
}
