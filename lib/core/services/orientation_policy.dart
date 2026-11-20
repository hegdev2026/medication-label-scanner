import 'dart:ui' as ui;

import 'package:flutter/services.dart';

/// Phones stay in portrait; tablets, foldables and desktop windows (shortest
/// side of 600 logical pixels or more) rotate freely, because the layouts there
/// use the extra width.
abstract final class OrientationPolicy {
  static const _phoneShortestSide = 600.0;

  static bool isPhone(ui.Size physicalSize, double devicePixelRatio) =>
      physicalSize.shortestSide / devicePixelRatio < _phoneShortestSide;

  static Future<void> apply() {
    final view = ui.PlatformDispatcher.instance.views.firstOrNull;
    if (view == null || !isPhone(view.physicalSize, view.devicePixelRatio)) {
      return SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    }
    return SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
    ]);
  }
}
