import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_seed.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_form_controllers.dart';
import 'package:medicine_lab_reader/features/search/presentation/widgets/add_to_inventory_button.dart';

void main() {
  test('a search seed fills only the names; dates and batch stay empty', () {
    final c = MedicineFormControllers(
      seed: const MedicineSeed(name: 'Crocin', genericName: 'Acetaminophen'),
    );
    addTearDown(c.dispose);
    expect(c.name.text, 'Crocin');
    expect(c.generic.text, 'Acetaminophen');
    expect(c.expiry.text, isEmpty);
    expect(c.batch.text, isEmpty);
    expect(c.strength.text, isEmpty);
    expect(c.expiryDate, isNull);
  });

  test('added from search is saved as a manual entry, not a scan', () {
    final c = MedicineFormControllers(seed: const MedicineSeed(name: 'Crocin'));
    addTearDown(c.dispose);
    final m = c.toMedicine(fromScan: false);
    expect(m.name, 'Crocin');
    expect(m.genericName, isNull);
    expect(m.reviewStatus, ReviewStatus.manual);
  });

  testWidgets('the button opens the add form with the seed', (t) async {
    Object? received;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(
            body: AddToInventoryButton(
              name: 'Pantop',
              genericName: 'Pantoprazole',
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.medicineNew,
          builder: (_, state) {
            received = state.extra;
            return const Scaffold(body: Text('form'));
          },
        ),
      ],
    );
    await t.pumpWidget(MaterialApp.router(routerConfig: router));
    await t.tap(find.byType(AddToInventoryButton));
    await t.pumpAndSettle();
    expect(find.text('form'), findsOneWidget);
    expect(
      received,
      const MedicineSeed(name: 'Pantop', genericName: 'Pantoprazole'),
    );
  });
}
