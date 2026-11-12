import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_lab_reader/common/widgets/skeleton_rows.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_palette.dart';
import 'package:medicine_lab_reader/features/dashboard/presentation/widgets/dashboard_skeleton.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_card_skeleton.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_screen_skeletons.dart';

/// Every loading skeleton must lay out on a small phone without overflow, in
/// both themes.
void main() {
  final skeletons = <String, Widget>{
    'dashboard': const DashboardSkeleton(),
    'details': const MedicineDetailsSkeleton(),
    'form': const MedicineFormSkeleton(),
    'list': const SingleChildScrollView(child: MedicineListSkeleton()),
    'rows': const Column(children: [SummaryRowSkeleton(), ChipRowSkeleton()]),
  };

  for (final dark in [false, true]) {
    for (final e in skeletons.entries) {
      testWidgets('${e.key} skeleton lays out (${dark ? 'dark' : 'light'})', (
        t,
      ) async {
        AppColors.palette = dark ? AppPalette.dark : AppPalette.light;
        addTearDown(() => AppColors.palette = AppPalette.light);
        t.view.physicalSize = const Size(360, 740);
        t.view.devicePixelRatio = 1;
        addTearDown(t.view.reset);
        await t.pumpWidget(MaterialApp(home: Scaffold(body: e.value)));
        await t.pump(const Duration(milliseconds: 300));
        expect(t.takeException(), isNull);
      });
    }
  }
}
