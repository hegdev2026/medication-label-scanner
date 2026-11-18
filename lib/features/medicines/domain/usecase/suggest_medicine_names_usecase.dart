import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/domain/repo/medicine_info_repository.dart';

/// "Did you mean" names for a search that found nothing.
@lazySingleton
class SuggestMedicineNamesUsecase implements UseCase<List<String>, String> {
  SuggestMedicineNamesUsecase(this._repo);
  final MedicineInfoRepository _repo;

  @override
  Future<Either<Failure, List<String>>> call(String params) =>
      _repo.suggestions(params);
}
