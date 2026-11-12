import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

/// Rounded-square icon, title/subtitle and an optional trailing widget.
class DetailsCardHeader extends StatelessWidget {
  const DetailsCardHeader({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.iconBg,
    this.iconFg,
    this.titleColor,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color? iconBg, iconFg, titleColor;

  @override
  Widget build(BuildContext context) {
    final sub = subtitle;
    final end = trailing;
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconBg ?? AppColors.inset,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Icon(icon, size: 20, color: iconFg ?? AppColors.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppText.titleSm.bold.tinted(
                  titleColor ?? AppColors.textPrimary,
                ),
              ),
              if (sub != null)
                Text(
                  sub,
                  style: AppText.labelSm.regular.tinted(
                    AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        ?end,
      ],
    );
  }
}
