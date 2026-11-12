import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';

/// The elevated central scan trigger: forest green with a soft mint halo.
class NavScanButton extends StatelessWidget {
  const NavScanButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'scan.title'.tr(),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 24,
              spreadRadius: -4,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.4),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          Icons.document_scanner_outlined,
          size: 28,
          color: AppColors.isDark ? AppColors.onAccentFill : AppColors.onAccent,
        ),
      ),
    ),
  );
}
