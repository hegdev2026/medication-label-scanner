import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/domain/repo/medicine_repository.dart';

@lazySingleton
class GetMedicineUsecase implements UseCase<Medicine?, int> {
  GetMedicineUsecase(this._repo);
  final MedicineRepository _repo;

  @override
  Future<Either<Failure, Medicine?>> call(int id) => _repo.getById(id);
}
