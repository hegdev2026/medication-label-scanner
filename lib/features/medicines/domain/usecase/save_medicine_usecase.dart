import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/domain/repo/medicine_repository.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/image_storage.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/reminder_scheduler.dart';

/// Stores the image privately, saves the record and refreshes reminders.
@lazySingleton
class SaveMedicineUsecase implements UseCase<int, Medicine> {
  SaveMedicineUsecase(this._repo, this._images, this._reminders);
  final MedicineRepository _repo;
  final ImageStorage _images;
  final ReminderScheduler _reminders;

  @override
  Future<Either<Failure, int>> call(Medicine medicine) async {
    var m = medicine;
    final path = m.imagePath;
    if (path != null && path.isNotEmpty) {
      try {
        m = m.copyWith(imagePath: await _images.persist(path));
      } catch (e) {
        return Left(StorageFailure(detail: '$e'));
      }
    }
    final saved = await _repo.save(m);
    return saved.fold(Left.new, (id) async {
      await _reminders.cancel(id);
      await _reminders.schedule(m.copyWith(id: id));
      return Right(id);
    });
  }
}
