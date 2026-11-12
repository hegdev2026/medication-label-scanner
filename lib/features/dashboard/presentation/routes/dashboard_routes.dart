import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/core/router/feature_routes.dart';
import 'package:medicine_lab_reader/features/dashboard/presentation/pages/dashboard_page.dart';

final dashboardRoutes = FeatureRoutes(
  tab: [
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (_, _) => const DashboardPage(),
    ),
  ],
);
