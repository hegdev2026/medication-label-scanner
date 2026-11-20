import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/reminder_scheduler.dart';

/// Asks for notification permission. Runs first at launch, before the ad
/// consent form, so the person decides about reminders up front.
@lazySingleton
class RequestNotificationPermissionUsecase implements UseCase<bool, NoParams> {
  RequestNotificationPermissionUsecase(this._reminders);
  final ReminderScheduler _reminders;

  @override
  Future<Either<Failure, bool>> call(NoParams params) async =>
      Right(await _reminders.requestPermission());
}
