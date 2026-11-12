import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/core/router/feature_routes.dart';
import 'package:medicine_lab_reader/core/router/navigator_keys.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/image_source_service.dart';
import 'package:medicine_lab_reader/features/scanner/presentation/pages/scan_page.dart';

final scannerRoutes = FeatureRoutes(
  fullScreen: [
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: AppRoutes.scan,
      builder: (_, state) => ScanPage(
        initialOrigin: state.uri.queryParameters['source'] == 'gallery'
            ? ImageOrigin.gallery
            : null,
      ),
    ),
  ],
);
