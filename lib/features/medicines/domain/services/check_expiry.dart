import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/di/register_module.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/expiry_status.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';

/// Expiry categorisation. Pure date logic, no I/O.
@lazySingleton
class CheckExpiry {
  CheckExpiry(this._clock);
  final Clock _clock;

  ExpiryStatus call(Medicine m) => statusFor(m.expiryDate, _clock.now());

  static ExpiryStatus statusFor(DateTime? expiry, DateTime now) {
    if (expiry == null) return ExpiryStatus.none;
    final days = DateTime(
      expiry.year,
      expiry.month,
      expiry.day,
    ).difference(DateTime(now.year, now.month, now.day)).inDays;
    if (days < 0) return ExpiryStatus.expired;
    if (days <= 30) return ExpiryStatus.within30;
    if (days <= 60) return ExpiryStatus.within60;
    if (days <= 90) return ExpiryStatus.within90;
    return ExpiryStatus.ok;
  }
}
