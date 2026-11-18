import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:medicine_lab_reader/core/router/app_router.dart';
import 'package:medicine_lab_reader/core/router/app_routes.dart';

String _path(RouteBase r) => r is GoRoute ? r.path : '';

void main() {
  test('tab modules keep the bottom-navigation order', () {
    final paths = [for (final m in AppRouter.tabModules) _path(m.tab.single)];
    expect(paths, [
      AppRoutes.dashboard,
      AppRoutes.search,
      AppRoutes.inventory,
      AppRoutes.expiry,
      AppRoutes.settings,
    ]);
  });

  test('every full-screen path is registered once', () {
    final paths = [
      for (final m in AppRouter.modules)
        for (final r in m.fullScreen) _path(r),
    ];
    expect(paths.toSet().length, paths.length);
    expect(
      paths,
      containsAll([
        AppRoutes.scan,
        AppRoutes.review,
        AppRoutes.medicineNew,
        AppRoutes.medicineDetails,
      ]),
    );
  });
}
