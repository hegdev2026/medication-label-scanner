import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/adaptive/form_factor.dart';
import 'package:medicine_lab_reader/core/constants/app_breakpoints.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';

/// Centres content with a max width and form-factor padding.
class ContentWrapper extends StatelessWidget {
  const ContentWrapper({
    super.key,
    required this.child,
    this.scrollable = false,
    this.maxWidth = AppBreakpoints.maxContentWidth,
    this.safeBottom = true,
  });
  final Widget child;
  final bool scrollable;
  final double maxWidth;

  /// Scrolling content ends above the system navigation bar / home indicator.
  /// Off when something below already takes care of it (a pinned dock).
  final bool safeBottom;

  @override
  Widget build(BuildContext context) {
    final pad = context.byFormFactor(
      mobile: AppSpace.margin,
      tablet: 24.0,
      desktop: 32.0,
    );
    final padded = Padding(padding: EdgeInsets.all(pad), child: child);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: scrollable
            ? SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.viewInsetsOf(context).bottom > 0
                      ? AppSpace.xxl
                      : (safeBottom ? MediaQuery.paddingOf(context).bottom : 0),
                ),
                child: padded,
              )
            : padded,
      ),
    );
  }
}
