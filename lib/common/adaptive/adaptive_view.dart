import 'package:flutter/widgets.dart';
import 'package:medicine_lab_reader/common/adaptive/form_factor.dart';

/// Shows a feature's mobile, tablet or desktop UI, whichever fits the screen.
///
/// It is the one place a screen branches on form factor. The builders live in
/// the feature's own `mobile/` and `tab/` folders and share everything below
/// the UI — blocs, usecases, entities — because the blocs are provided *above*
/// this widget, by the feature's page, and survive a switch:
///
/// ```dart
/// AdaptiveView(
///   mobile: (_) => const PatientListMobileView(),
///   tablet: (_) => const PatientListTabView(),
///   // desktop: (_) => const PatientListDesktopView(),  // optional
/// )
/// ```
///
/// [desktop] is optional: without it a wide window gets the tablet UI. Only the
/// builder of the active form factor runs. Each branch is keyed, so when the
/// screen crosses a breakpoint the old subtree is disposed instead of being
/// reused for the other layout; state the user typed into a form lives in a
/// bloc/cubit above this widget, not in the views.
class AdaptiveView extends StatelessWidget {
  const AdaptiveView({
    super.key,
    required this.mobile,
    required this.tablet,
    this.desktop,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder tablet;
  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    final factor = context.formFactor;
    final builder = switch (factor) {
      FormFactor.mobile => mobile,
      FormFactor.tablet => tablet,
      FormFactor.desktop => desktop ?? tablet,
    };
    // Keyed by the builder actually used, so a desktop window that falls back
    // to the tablet UI is not rebuilt when it moves between tablet and desktop.
    final shown = builder == mobile
        ? FormFactor.mobile
        : (builder == tablet ? FormFactor.tablet : FormFactor.desktop);
    return KeyedSubtree(key: ValueKey(shown), child: builder(context));
  }
}

/// Builds from the screen's size, for conditional layouts that are not a whole
/// separate UI — wrap a section, branch on `screen.isMobile`,
/// `screen.atLeast(WindowSizeClass.expanded)` or `screen.isLandscape`.
///
/// By default it measures the **screen**. Pass [useParentConstraints] to measure
/// the space the parent gave it instead (a card in a split view is narrower than
/// the screen); the size class and form factor then describe that box.
class ScreenSizeBuilder extends StatelessWidget {
  const ScreenSizeBuilder({
    super.key,
    required this.builder,
    this.useParentConstraints = false,
  });

  final Widget Function(BuildContext context, ScreenInfo screen) builder;
  final bool useParentConstraints;

  @override
  Widget build(BuildContext context) {
    if (!useParentConstraints) return builder(context, context.screen);
    return LayoutBuilder(
      builder: (context, constraints) {
        final box = constraints.biggest;
        final orientation = box.width >= box.height
            ? Orientation.landscape
            : Orientation.portrait;
        return builder(context, ScreenInfo(box, orientation));
      },
    );
  }
}
