import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/app_update/domain/entities/app_update_info.dart';
import 'package:medicine_lab_reader/features/app_update/domain/services/app_update_service.dart';

/// Is a newer version waiting on Google Play? A failed check offers nothing.
@lazySingleton
class CheckAppUpdateUsecase implements UseCase<AppUpdateInfo?, NoParams> {
  CheckAppUpdateUsecase(this._service);
  final AppUpdateService _service;

  @override
  Future<Either<Failure, AppUpdateInfo?>> call(NoParams params) async {
    try {
      return Right(await _service.check());
    } on Exception catch (e) {
      return Left(UnknownFailure(detail: '$e'));
    }
  }
}
