import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';

abstract interface class ReminderScheduler {
  Future<void> schedule(Medicine medicine);
  Future<void> cancel(int medicineId);
  Future<void> rescheduleAll(List<Medicine> medicines);
}
