import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/domain/repo/medicine_repository.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/reminder_scheduler.dart';

/// Recalculates reminders for every record (called at app start).
@lazySingleton
class RescheduleRemindersUsecase implements UseCase<Unit, NoParams> {
  RescheduleRemindersUsecase(this._repo, this._reminders);
  final MedicineRepository _repo;
  final ReminderScheduler _reminders;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    final all = await _repo.getAll();
    return all.fold(Left.new, (list) async {
      await _reminders.rescheduleAll(list);
      return const Right(unit);
    });
  }
}
