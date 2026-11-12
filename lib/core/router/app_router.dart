import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/core/router/feature_routes.dart';
import 'package:medicine_lab_reader/core/router/navigator_keys.dart';
import 'package:medicine_lab_reader/features/dashboard/presentation/routes/dashboard_routes.dart';
import 'package:medicine_lab_reader/features/expiry/presentation/routes/expiry_routes.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/routes/medicines_routes.dart';
import 'package:medicine_lab_reader/features/scanner/presentation/routes/scanner_routes.dart';
import 'package:medicine_lab_reader/features/settings/presentation/routes/settings_routes.dart';
import 'package:medicine_lab_reader/features/shell/presentation/pages/app_shell.dart';

/// Assembles the router from the feature modules; it holds no routes itself.
@lazySingleton
class AppRouter {
  /// Modules shown as bottom-navigation tabs, in tab order. Keep this in step
  /// with the shell's navigation destinations.
  static final List<FeatureRoutes> tabModules = [
    dashboardRoutes,
    medicinesRoutes,
    expiryRoutes,
    settingsRoutes,
  ];

  /// Every module, tab or not; their full-screen routes sit above the shell.
  static final List<FeatureRoutes> modules = [...tabModules, scannerRoutes];

  late final GoRouter config = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.dashboard,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(shell: shell),
        branches: [
          for (final m in tabModules) StatefulShellBranch(routes: m.tab),
        ],
      ),
      for (final m in modules) ...m.fullScreen,
    ],
  );
}
