import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/form_hints.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_seed.dart';
import 'package:medicine_lab_reader/features/medicines/domain/repo/form_hints_repository.dart';

@lazySingleton
class GetFormHintsUsecase implements UseCase<FormHints, MedicineSeed> {
  GetFormHintsUsecase(this._repo);
  final FormHintsRepository _repo;

  @override
  Future<Either<Failure, FormHints>> call(MedicineSeed seed) =>
      _repo.hintsFor(name: seed.name, genericName: seed.genericName);
}
