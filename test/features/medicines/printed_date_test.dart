import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/check_expiry.dart';
import 'package:medicine_lab_reader/features/medicines/domain/value_objects/printed_date.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/expiry_status.dart';

void main() {
  test('month-only date maps to end of month and keeps original', () {
    final d = PrintedDate.parse('EXP 04/2027')!;
    expect(d.toDateTime(), DateTime(2027, 4, 30));
    expect(d.original, '04/2027');
  });

  test('named month and full dates', () {
    expect(PrintedDate.parse('APR 2027')!.month, 4);
    expect(PrintedDate.parse('15/04/2027')!.day, 15);
    expect(PrintedDate.parse('13/2027'), isNull);
  });

  test('expiry statuses', () {
    final now = DateTime(2026, 1, 1);
    expect(CheckExpiry.statusFor(null, now), ExpiryStatus.none);
    expect(
      CheckExpiry.statusFor(DateTime(2025, 12, 31), now),
      ExpiryStatus.expired,
    );
    expect(
      CheckExpiry.statusFor(DateTime(2026, 1, 20), now),
      ExpiryStatus.within30,
    );
    expect(
      CheckExpiry.statusFor(DateTime(2026, 3, 1), now),
      ExpiryStatus.within60,
    );
    expect(
      CheckExpiry.statusFor(DateTime(2026, 4, 1), now),
      ExpiryStatus.within90,
    );
    expect(CheckExpiry.statusFor(DateTime(2027, 1, 1), now), ExpiryStatus.ok);
  });
}
