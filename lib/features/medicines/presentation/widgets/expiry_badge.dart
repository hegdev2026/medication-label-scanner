import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/expiry_status.dart';

class ExpiryBadge extends StatelessWidget {
  const ExpiryBadge({super.key, required this.status});
  final ExpiryStatus status;

  static Color colorOf(ExpiryStatus s) => switch (s) {
    ExpiryStatus.expired => AppColors.expired,
    ExpiryStatus.within30 ||
    ExpiryStatus.within60 ||
    ExpiryStatus.within90 => AppColors.expiringSoon,
    ExpiryStatus.ok => AppColors.expiryOk,
    ExpiryStatus.none => AppColors.expiryNone,
  };

  @override
  Widget build(BuildContext context) {
    final color = colorOf(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status.labelKey.tr(), style: AppText.labelMd.tinted(color)),
    );
  }
}
