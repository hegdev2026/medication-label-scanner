import 'package:flutter/material.dart';

/// Gives its space back while the keyboard is open, so bars and buttons pinned
/// to the bottom never ride up above the keyboard and squeeze the form. They
/// return once the keyboard closes.
class HideWhenKeyboard extends StatelessWidget {
  const HideWhenKeyboard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final open = MediaQuery.viewInsetsOf(context).bottom > 0;
    return open ? const SizedBox.shrink() : child;
  }
}
