import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_palette.dart';

/// Installs the active palette into [AppColors], fades between palettes when
/// the theme changes, and repaints the whole tree when the palette or the
/// [locale] changes.
///
/// `AppColors` and `tr()` reads are not Inherited, so widgets that do not
/// depend on the theme or on Localizations (const children, buildWhen-guarded
/// blocs, off-screen tabs) would keep showing the old look or language until
/// something else rebuilt them. Every descendant is marked dirty here, in the
/// same frame, so the change shows at once. During a fade this happens on
/// every animation frame, including the last one.
class ThemeScope extends StatefulWidget {
  const ThemeScope({
    super.key,
    required this.palette,
    required this.locale,
    required this.builder,
    this.fade = const Duration(milliseconds: 320),
  });
  final AppPalette palette;
  final Locale locale;

  /// Builds the app with the palette to show right now (mid-fade it is a
  /// blend of the old and the new one).
  final Widget Function(BuildContext context, AppPalette palette) builder;
  final Duration fade;

  @override
  State<ThemeScope> createState() => _ThemeScopeState();
}

class _ThemeScopeState extends State<ThemeScope>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.fade,
    value: 1,
  );
  late AppPalette _from = widget.palette;
  late AppPalette _to = widget.palette;

  /// Fade position at the last repaint of the whole tree.
  double _painted = 1;

  AppPalette get _current => AppPalette.lerp(
    _from,
    _to,
    Curves.easeInOutCubic.transform(_controller.value),
  );

  @override
  void initState() {
    super.initState();
    AppColors.palette = widget.palette;
  }

  @override
  void didUpdateWidget(ThemeScope old) {
    super.didUpdateWidget(old);
    if (!identical(old.palette, widget.palette)) {
      _from = _current;
      _to = widget.palette;
      _controller
        ..duration = widget.fade
        ..forward(from: 0);
    }
    if (!identical(old.palette, widget.palette) ||
        old.locale != widget.locale) {
      // Marking descendants dirty while this element builds is allowed, and
      // they are rebuilt later in the same frame (no extra frame needed).
      _markAll(context as Element);
      _painted = _controller.value;
    }
  }

  void _markAll(Element e) {
    e.visitChildren((c) {
      c.markNeedsBuild();
      _markAll(c);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, _) {
      final palette = _current;
      AppColors.palette = palette;
      if (_controller.value != _painted) {
        _painted = _controller.value;
        _markAll(context as Element);
      }
      return widget.builder(context, palette);
    },
  );
}
