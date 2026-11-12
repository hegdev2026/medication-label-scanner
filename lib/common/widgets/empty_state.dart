import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
  });
  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final msg = message;
    final act = action;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.textMuted),
            const SizedBox(height: AppSpace.md),
            Text(title, style: AppText.titleMd, textAlign: TextAlign.center),
            if (msg != null) ...[
              const SizedBox(height: AppSpace.xs),
              Text(msg, textAlign: TextAlign.center, style: AppText.bodySm),
            ],
            if (act != null) ...[const SizedBox(height: AppSpace.lg), act],
          ],
        ),
      ),
    );
  }
}
