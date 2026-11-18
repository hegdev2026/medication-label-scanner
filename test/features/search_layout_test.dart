import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_palette.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/prescription_notes_card.dart';
import 'package:medicine_lab_reader/features/shell/presentation/widgets/mobile_bottom_nav.dart';

/// The five-tab bottom bar and the notes card must fit a small phone in both
/// themes.
void main() {
  for (final dark in [false, true]) {
    for (final width in [320.0, 360.0, 411.0]) {
      testWidgets(
        'bottom nav fits ${width.toInt()}px (${dark ? 'dark' : 'light'})',
        (t) async {
          AppColors.palette = dark ? AppPalette.dark : AppPalette.light;
          addTearDown(() => AppColors.palette = AppPalette.light);
          t.view.physicalSize = Size(width, 740);
          t.view.devicePixelRatio = 1;
          addTearDown(t.view.reset);
          await t.pumpWidget(
            MaterialApp(
              home: Scaffold(
                bottomNavigationBar: MobileBottomNav(
                  index: 1,
                  onSelected: (_) {},
                ),
                body: const SingleChildScrollView(
                  child: PrescriptionNotesCard(),
                ),
              ),
            ),
          );
          expect(t.takeException(), isNull);
        },
      );
    }
  }
}
