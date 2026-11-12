import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_palette.dart';
import 'package:medicine_lab_reader/core/theme/theme_scope.dart';

/// Const leaf that reads static state, like `AppColors` / `tr()` do: nothing
/// but ThemeScope can tell it to rebuild.
class _Leaf extends StatelessWidget {
  const _Leaf();

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: AppColors.card,
    child: Text(AppColors.isDark ? 'dark' : 'light'),
  );
}

void main() {
  Widget host(ValueNotifier<(AppPalette, Locale)> v) => ValueListenableBuilder(
    valueListenable: v,
    builder: (_, value, _) => Directionality(
      textDirection: TextDirection.ltr,
      child: ThemeScope(
        palette: value.$1,
        locale: value.$2,
        child: const _Leaf(),
      ),
    ),
  );

  testWidgets('palette change reaches const widgets in the same frame', (
    t,
  ) async {
    final v = ValueNotifier((AppPalette.light, const Locale('en')));
    await t.pumpWidget(host(v));
    expect(find.text('light'), findsOneWidget);
    v.value = (AppPalette.dark, const Locale('en'));
    await t.pump(); // a single frame, no further interaction
    expect(find.text('dark'), findsOneWidget);
    AppColors.palette = AppPalette.light;
  });

  testWidgets('locale change rebuilds const widgets in the same frame', (
    t,
  ) async {
    var builds = 0;
    final v = ValueNotifier((AppPalette.light, const Locale('en')));
    await t.pumpWidget(
      ValueListenableBuilder(
        valueListenable: v,
        builder: (_, value, _) => Directionality(
          textDirection: TextDirection.ltr,
          child: ThemeScope(
            palette: value.$1,
            locale: value.$2,
            child: Builder(
              builder: (_) {
                builds++;
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
    final before = builds;
    v.value = (AppPalette.light, const Locale('hi'));
    await t.pump();
    expect(builds, greaterThan(before));
  });
}
