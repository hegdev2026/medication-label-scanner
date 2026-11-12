/// Shared responsive breakpoints. Form factor is decided on the screen's
/// shortest side (see `common/adaptive/`).
class AppBreakpoints {
  AppBreakpoints._();

  /// Material's phone/tablet split, on the screen's shortest side.
  static const double tabletShortestSide = 600;

  /// Width at which a wide window gets the desktop UI.
  static const double desktop = 1024;

  /// Material 3 window size classes by width.
  static const double expanded = 840;
  static const double large = 1200;
  static const double extraLarge = 1600;

  /// Max width of centred page content.
  static const double maxContentWidth = 1200;
}
