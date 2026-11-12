import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_palette.dart';

/// Installs the active palette into [AppColors] and repaints the whole tree
/// when the palette or the [locale] changes.
///
/// `AppColors` and `tr()` reads are not Inherited, so widgets that do not
/// depend on the theme or on Localizations (const children, buildWhen-guarded
/// blocs, off-screen tabs) would keep showing the old look or language until
/// something else rebuilt them. Every descendant is marked dirty here, in the
/// same frame, so the change shows at once.
class ThemeScope extends StatefulWidget {
  const ThemeScope({
    super.key,
    required this.palette,
    required this.locale,
    required this.child,
  });
  final AppPalette palette;
  final Locale locale;
  final Widget child;

  @override
  State<ThemeScope> createState() => _ThemeScopeState();
}

class _ThemeScopeState extends State<ThemeScope> {
  @override
  void initState() {
    super.initState();
    AppColors.palette = widget.palette;
  }

  @override
  void didUpdateWidget(ThemeScope old) {
    super.didUpdateWidget(old);
    final paletteChanged = !identical(old.palette, widget.palette);
    if (paletteChanged) AppColors.palette = widget.palette;
    if (paletteChanged || old.locale != widget.locale) {
      // Marking descendants dirty while this element builds is allowed, and
      // they are rebuilt later in the same frame (no extra frame needed).
      _markAll(context as Element);
    }
  }

  void _markAll(Element e) {
    e.visitChildren((c) {
      c.markNeedsBuild();
      _markAll(c);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
