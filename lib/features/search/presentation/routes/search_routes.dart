import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/core/router/feature_routes.dart';
import 'package:medicine_lab_reader/features/search/presentation/pages/search_page.dart';

final searchRoutes = FeatureRoutes(
  tab: [GoRoute(path: AppRoutes.search, builder: (_, _) => const SearchPage())],
);
