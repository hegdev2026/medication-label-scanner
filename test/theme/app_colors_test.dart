import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_palette.dart';

void main() {
  tearDown(() => AppColors.palette = AppPalette.light);

  test('tokens follow the active palette', () {
    AppColors.palette = AppPalette.light;
    final lightText = AppColors.textPrimary;
    final lightBg = AppColors.background;
    AppColors.palette = AppPalette.dark;
    expect(AppColors.isDark, isTrue);
    expect(AppColors.textPrimary, isNot(lightText));
    expect(AppColors.background, isNot(lightBg));
  });

  test('text never equals its background in either theme', () {
    for (final p in [AppPalette.light, AppPalette.dark]) {
      expect(p.textPrimary, isNot(p.background));
      expect(p.textPrimary, isNot(p.card));
    }
  });
}
