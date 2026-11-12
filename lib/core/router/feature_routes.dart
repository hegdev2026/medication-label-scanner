import 'package:go_router/go_router.dart';

/// Everything one feature module contributes to the router.
///
/// Each feature owns one of these in `presentation/routes/<feature>_routes.dart`
/// and `AppRouter` only lists the modules, so adding a screen never touches the
/// router itself.
class FeatureRoutes {
  const FeatureRoutes({this.tab = const [], this.fullScreen = const []});

  /// Routes shown inside the app shell as one bottom-navigation tab. Empty for
  /// modules that are not a tab.
  final List<RouteBase> tab;

  /// Routes pushed over the shell on the root navigator (no bottom bar).
  final List<RouteBase> fullScreen;
}
