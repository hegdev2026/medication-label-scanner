import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/image_source_service.dart';

/// Lets the user pick/capture an image. Right(null) means they cancelled.
@lazySingleton
class PickImageUsecase implements UseCase<String?, ImageOrigin> {
  PickImageUsecase(this._source);
  final ImageSourceService _source;

  bool get cameraSupported => _source.cameraSupported;

  @override
  Future<Either<Failure, String?>> call(ImageOrigin origin) async {
    try {
      return Right(await _source.pick(origin));
    } catch (e) {
      return Left(ImagePickFailure(detail: '$e'));
    }
  }
}
