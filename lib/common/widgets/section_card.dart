import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    this.title,
    this.trailing,
    required this.child,
  });
  final String? title;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final heading = title;
    return AppSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (heading != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.md),
              child: Row(
                children: [
                  Expanded(child: Text(heading, style: AppText.titleMd)),
                  ?trailing,
                ],
              ),
            ),
          child,
        ],
      ),
    );
  }
}
