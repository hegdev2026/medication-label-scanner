import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/theme/app_metrics.dart';

/// Lays children out in as many equal columns as fit [minItemWidth].
class AdaptiveGrid extends StatelessWidget {
  const AdaptiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 220,
    this.spacing = AppSpace.md,
  });
  final List<Widget> children;
  final double minItemWidth;
  final double spacing;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      final fit = ((c.maxWidth + spacing) / (minItemWidth + spacing)).floor();
      final cols = math.max(1, math.min(fit, math.max(1, children.length)));
      final w = (c.maxWidth - spacing * (cols - 1)) / cols;
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [for (final ch in children) SizedBox(width: w, child: ch)],
      );
    },
  );
}
