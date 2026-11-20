import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/app_update/domain/services/app_update_service.dart';

/// Installs a finished download and restarts the app.
@lazySingleton
class InstallAppUpdateUsecase implements UseCase<Unit, NoParams> {
  InstallAppUpdateUsecase(this._service);
  final AppUpdateService _service;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    try {
      await _service.install();
      return const Right(unit);
    } on Exception catch (e) {
      return Left(UnknownFailure(detail: '$e'));
    }
  }
}
