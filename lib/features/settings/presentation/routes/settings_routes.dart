import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/core/router/feature_routes.dart';
import 'package:medicine_lab_reader/core/router/navigator_keys.dart';
import 'package:medicine_lab_reader/features/settings/domain/services/legal_documents.dart';
import 'package:medicine_lab_reader/features/settings/presentation/pages/legal_page.dart';
import 'package:medicine_lab_reader/features/settings/presentation/pages/settings_page.dart';

final settingsRoutes = FeatureRoutes(
  tab: [
    GoRoute(path: AppRoutes.settings, builder: (_, _) => const SettingsPage()),
  ],
  fullScreen: [
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: AppRoutes.terms,
      builder: (_, _) => LegalPage(document: LegalDocuments.terms),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: AppRoutes.privacy,
      builder: (_, _) => LegalPage(document: LegalDocuments.privacy),
    ),
  ],
);
