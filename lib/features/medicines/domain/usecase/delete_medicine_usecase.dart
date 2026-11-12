import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/domain/repo/medicine_repository.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/image_storage.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/reminder_scheduler.dart';

@lazySingleton
class DeleteMedicineUsecase implements UseCase<Unit, Medicine> {
  DeleteMedicineUsecase(this._repo, this._images, this._reminders);
  final MedicineRepository _repo;
  final ImageStorage _images;
  final ReminderScheduler _reminders;

  @override
  Future<Either<Failure, Unit>> call(Medicine medicine) async {
    final id = medicine.id;
    if (id == null) return const Right(unit);
    await _reminders.cancel(id);
    final result = await _repo.delete(id);
    if (result.isRight()) {
      try {
        await _images.delete(medicine.imagePath);
      } catch (_) {
        // The record is gone; a leftover image file is harmless.
      }
    }
    return result;
  }
}
