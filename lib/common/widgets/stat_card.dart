import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color,
    this.onTap,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return AppSurface(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: c.withValues(alpha: 0.15),
            child: Icon(icon, color: c),
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: AppText.headingMd),
                Text(label, style: AppText.bodySm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
