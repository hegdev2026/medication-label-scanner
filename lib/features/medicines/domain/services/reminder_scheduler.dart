import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';

abstract interface class ReminderScheduler {
  /// Asks the OS for permission to show reminders (once; the OS remembers).
  /// True when reminders can be delivered on this platform.
  Future<bool> requestPermission();

  Future<void> schedule(Medicine medicine);
  Future<void> cancel(int medicineId);
  Future<void> rescheduleAll(List<Medicine> medicines);
}
