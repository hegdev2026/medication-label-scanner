import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_pill.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/expiry_status.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/check_expiry.dart';

/// "Exp: Dec 2026" pill, coloured by how close the printed date is. The text is
/// the date as printed; the colour is only a reminder, never a safety verdict.
class ExpiryPill extends StatelessWidget {
  const ExpiryPill({super.key, required this.medicine});
  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    final expiry = medicine.expiryDate;
    final status = CheckExpiry.statusFor(expiry, DateTime.now());
    final label = expiry == null
        ? 'expiry.none'.tr()
        : 'inventory.expShort'.tr(
            args: [
              medicine.originalExpiryText ??
                  DateFormat.yMMM(context.locale.toString()).format(expiry),
            ],
          );
    final (tone, icon) = switch (status) {
      ExpiryStatus.expired => (AppPillTone.danger, Icons.error_outline),
      ExpiryStatus.within30 ||
      ExpiryStatus.within60 ||
      ExpiryStatus.within90 => (AppPillTone.warning, Icons.alarm),
      ExpiryStatus.ok => (AppPillTone.mint, Icons.alarm),
      ExpiryStatus.none => (AppPillTone.neutral, Icons.help_outline),
    };
    return AppPill(label: label, tone: tone, icon: icon);
  }
}
