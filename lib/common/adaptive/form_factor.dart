import 'package:flutter/widgets.dart';
import 'package:medicine_lab_reader/core/constants/app_breakpoints.dart';

/// Which of a feature's UIs the screen gets. Decides *which widget tree* is
/// built (see `AdaptiveView`); use [WindowSizeClass] for finer adjustments
/// inside one tree.
///
/// * [mobile]  — a phone, upright or on its side.
/// * [tablet]  — a tablet, or a window too narrow for the desktop layout.
/// * [desktop] — a wide window: width of at least [AppBreakpoints.desktop].
///
/// A screen is *mobile* by its **shortest side**, not its width, so a phone held
/// sideways stays a phone and its UI does not swap under the user when it
/// rotates. A UI that has no [desktop] build simply gets the tablet one.
enum FormFactor { mobile, tablet, desktop }

/// Material 3 window size classes, by width. Finer than [FormFactor]; meant for
/// decisions inside a screen: `compact` → one column, `expanded` → two, `large`
/// → add a side panel.
enum WindowSizeClass { compact, medium, expanded, large, extraLarge }

/// Everything a layout decision needs to know about the screen, calculated once
/// from its size.
@immutable
class ScreenInfo {
  const ScreenInfo(this.size, this.orientation);

  /// The screen's logical size.
  final Size size;
  final Orientation orientation;

  double get width => size.width;
  double get height => size.height;
  double get shortestSide => size.shortestSide;
  double get longestSide => size.longestSide;

  bool get isLandscape => orientation == Orientation.landscape;
  bool get isPortrait => orientation == Orientation.portrait;

  FormFactor get formFactor => formFactorForSize(size);

  bool get isMobile => formFactor == FormFactor.mobile;
  bool get isTablet => formFactor == FormFactor.tablet;
  bool get isDesktop => formFactor == FormFactor.desktop;

  /// At least tablet-sized (tablet or desktop).
  bool get isTabletOrLarger => formFactor != FormFactor.mobile;

  WindowSizeClass get sizeClass => windowSizeClassForWidth(width);

  /// `true` when [sizeClass] is [min] or wider.
  bool atLeast(WindowSizeClass min) => sizeClass.index >= min.index;

  @override
  bool operator ==(Object other) =>
      other is ScreenInfo &&
      other.size == size &&
      other.orientation == orientation;

  @override
  int get hashCode => Object.hash(size, orientation);

  @override
  String toString() => 'ScreenInfo($size, $formFactor, $sizeClass)';
}

/// The form factor for a screen of [size]. Pure, so it can be tested.
FormFactor formFactorForSize(Size size) {
  if (size.shortestSide < AppBreakpoints.tabletShortestSide) {
    return FormFactor.mobile;
  }
  return size.width >= AppBreakpoints.desktop
      ? FormFactor.desktop
      : FormFactor.tablet;
}

/// The Material 3 window size class for [width]. Pure.
WindowSizeClass windowSizeClassForWidth(double width) {
  if (width < AppBreakpoints.tabletShortestSide) return WindowSizeClass.compact;
  if (width < AppBreakpoints.expanded) return WindowSizeClass.medium;
  if (width < AppBreakpoints.large) return WindowSizeClass.expanded;
  if (width < AppBreakpoints.extraLarge) return WindowSizeClass.large;
  return WindowSizeClass.extraLarge;
}

extension ScreenContext on BuildContext {
  /// The screen's size, orientation and what they mean. Rebuilds the caller
  /// only when the screen *size* or orientation changes — not for the keyboard,
  /// which would otherwise tear a form down as it opens.
  ScreenInfo get screen =>
      ScreenInfo(MediaQuery.sizeOf(this), MediaQuery.orientationOf(this));

  FormFactor get formFactor => screen.formFactor;
  WindowSizeClass get sizeClass => screen.sizeClass;

  bool get isMobileUi => screen.isMobile;
  bool get isTabletUi => screen.isTablet;
  bool get isDesktopUi => screen.isDesktop;

  /// A small per-form-factor difference (a padding, a column count) that does
  /// not justify a second widget:
  /// `context.byFormFactor(mobile: 2, tablet: 4)`; [desktop] defaults to
  /// [tablet].
  T byFormFactor<T>({required T mobile, required T tablet, T? desktop}) =>
      switch (formFactor) {
        FormFactor.mobile => mobile,
        FormFactor.tablet => tablet,
        FormFactor.desktop => desktop ?? tablet,
      };
}
