import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/core/router/feature_routes.dart';
import 'package:medicine_lab_reader/core/router/navigator_keys.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_seed.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/pages/inventory_page.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/pages/medicine_details_page.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/pages/medicine_form_page.dart';
import 'package:medicine_lab_reader/features/scanner/domain/entities/extracted_details.dart';

int? _id(GoRouterState state) => int.tryParse(state.pathParameters['id'] ?? '');

/// The medicines module: the inventory tab plus its full-screen screens
/// (review, add, details, edit).
final medicinesRoutes = FeatureRoutes(
  tab: [
    GoRoute(
      path: AppRoutes.inventory,
      builder: (_, _) => const InventoryPage(),
    ),
  ],
  fullScreen: [
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: AppRoutes.review,
      builder: (_, state) {
        final extra = state.extra;
        return MedicineFormPage(draft: extra is ScanDraft ? extra : null);
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: AppRoutes.medicineNew,
      builder: (_, state) {
        final extra = state.extra;
        return MedicineFormPage(seed: extra is MedicineSeed ? extra : null);
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: AppRoutes.medicineDetails,
      builder: (_, state) => MedicineDetailsPage(id: _id(state) ?? -1),
      routes: [
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: 'edit',
          builder: (_, state) => MedicineFormPage(medicineId: _id(state)),
        ),
      ],
    ),
  ],
);
