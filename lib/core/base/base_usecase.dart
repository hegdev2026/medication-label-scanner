import 'package:dartz/dartz.dart';

import 'package:medicine_lab_reader/core/error/failures.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// For live queries. Errors surface through the stream itself.
abstract class StreamUseCase<T, Params> {
  Stream<T> call(Params params);
}

class NoParams {
  const NoParams();
}
