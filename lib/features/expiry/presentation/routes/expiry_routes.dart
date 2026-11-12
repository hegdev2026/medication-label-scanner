import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/core/router/feature_routes.dart';
import 'package:medicine_lab_reader/features/expiry/presentation/pages/expiry_tracker_page.dart';

final expiryRoutes = FeatureRoutes(
  tab: [
    GoRoute(
      path: AppRoutes.expiry,
      builder: (_, _) => const ExpiryTrackerPage(),
    ),
  ],
);
