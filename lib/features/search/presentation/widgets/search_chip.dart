import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

/// Tappable rounded chip holding a medicine name.
class SearchChip extends StatelessWidget {
  const SearchChip({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.card,
    shape: StadiumBorder(side: BorderSide(color: AppColors.border)),
    child: InkWell(
      customBorder: const StadiumBorder(),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.md,
          vertical: 10,
        ),
        child: Text(
          label,
          style: AppText.labelMd.tinted(AppColors.textPrimary),
        ),
      ),
    ),
  );
}
