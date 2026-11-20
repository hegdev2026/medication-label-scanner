import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/app_update/domain/entities/app_update_info.dart';
import 'package:medicine_lab_reader/features/app_update/domain/services/app_update_service.dart';

/// Starts the update. Right(false) means the person said no; Left means it
/// could not be started.
@lazySingleton
class StartAppUpdateUsecase implements UseCase<bool, AppUpdateMethod> {
  StartAppUpdateUsecase(this._service);
  final AppUpdateService _service;

  @override
  Future<Either<Failure, bool>> call(AppUpdateMethod params) async {
    try {
      return Right(await _service.start(params));
    } on Exception catch (e) {
      return Left(UnknownFailure(detail: '$e'));
    }
  }
}
