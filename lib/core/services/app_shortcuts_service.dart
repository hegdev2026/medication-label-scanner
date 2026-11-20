import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:quick_actions/quick_actions.dart';

import 'package:medicine_lab_reader/core/ads/app_open_gate.dart';
import 'package:medicine_lab_reader/core/router/app_router.dart';
import 'package:medicine_lab_reader/core/router/app_routes.dart';

/// Launcher shortcuts (long-press the app icon): scan, add, search, expiry.
/// Each shortcut has a stable `type` that maps to a route, so a tap goes
/// through the same router as in-app navigation. Android and iOS only.
///
/// The type doubles as the key of its label for [setTitles] callers and, on
/// Android, `res/drawable/ic_shortcut_<name>.xml` is its icon.
@lazySingleton
class AppShortcutsService {
  AppShortcutsService(this._router, this._appOpenGate);
  final AppRouter _router;
  final AppOpenGate _appOpenGate;
  final QuickActions _plugin = const QuickActions();
  bool _initialised = false;

  static const scan = 'action_scan';
  static const add = 'action_add';
  static const search = 'action_search';
  static const expiry = 'action_expiry';

  bool get _supported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// Starts listening; safe to call more than once. A shortcut that launched
  /// the app is delivered as soon as this runs.
  Future<void> init() async {
    if (!_supported || _initialised) return;
    _initialised = true;
    try {
      await _plugin.initialize(_open);
    } on Exception catch (e) {
      _initialised = false;
      debugPrint('Shortcuts unavailable: $e');
    }
  }

  /// Publishes the shortcuts with titles in the current language. Called again
  /// when the language changes.
  Future<void> setTitles({
    required String scanTitle,
    required String addTitle,
    required String searchTitle,
    required String expiryTitle,
  }) async {
    if (!_supported) return;
    String? icon(String name) => Platform.isAndroid ? name : null;
    try {
      await _plugin.setShortcutItems([
        ShortcutItem(
          type: scan,
          localizedTitle: scanTitle,
          icon: icon('ic_shortcut_scan'),
        ),
        ShortcutItem(
          type: add,
          localizedTitle: addTitle,
          icon: icon('ic_shortcut_add'),
        ),
        ShortcutItem(
          type: search,
          localizedTitle: searchTitle,
          icon: icon('ic_shortcut_search'),
        ),
        ShortcutItem(
          type: expiry,
          localizedTitle: expiryTitle,
          icon: icon('ic_shortcut_expiry'),
        ),
      ]);
    } on Exception catch (e) {
      debugPrint('Shortcuts not set: $e');
    }
  }

  Future<void> _open(String type) async {
    final target = switch (type) {
      scan => (base: AppRoutes.dashboard, push: AppRoutes.scan),
      add => (base: AppRoutes.inventory, push: AppRoutes.medicineNew),
      search => (base: AppRoutes.search, push: null),
      expiry => (base: AppRoutes.expiry, push: null),
      _ => null, // a shortcut from an older version: ignore it
    };
    if (target == null) return;
    // Coming back through a shortcut is not "opening" the app, and the person
    // is heading somewhere: no App Open ad in the way.
    _appOpenGate.holdFor(const Duration(seconds: 30), DateTime.now());
    final router = _router.config;
    final here = router.routerDelegate.currentConfiguration.uri.path;
    final push = target.push;
    // Already on the screen the shortcut opens: nothing to do.
    if (push != null && here == push) return;
    router.go(target.base);
    if (push == null) return;
    // `go` settles on the next frame; pushing in the same tick could be wiped
    // by it, most visibly on a cold start.
    await WidgetsBinding.instance.endOfFrame;
    if (router.routerDelegate.currentConfiguration.uri.path != target.base) {
      return; // something else took over (e.g. another shortcut): leave it
    }
    router.push(push);
  }
}
