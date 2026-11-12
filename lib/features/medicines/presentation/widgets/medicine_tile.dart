import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/check_expiry.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/expiry_badge.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_image.dart';

class MedicineTile extends StatelessWidget {
  const MedicineTile({
    super.key,
    required this.medicine,
    this.onTap,
    this.trailing,
  });
  final Medicine medicine;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final status = CheckExpiry.statusFor(medicine.expiryDate, DateTime.now());
    final expiry = medicine.expiryDate;
    final strength = medicine.strength;
    final subtitle = [
      ?strength,
      if (expiry != null)
        'inventory.expShort'.tr(
          args: [
            medicine.originalExpiryText ??
                DateFormat.yMMM(context.locale.toString()).format(expiry),
          ],
        ),
    ].join(' · ');
    return AppSurface(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpace.md),
      child: Row(
        children: [
          MedicineImage(path: medicine.imagePath, size: 56),
          const SizedBox(width: AppSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.titleMd,
                ),
                if (subtitle.isNotEmpty) Text(subtitle, style: AppText.bodySm),
                const SizedBox(height: 6),
                ExpiryBadge(status: status),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
