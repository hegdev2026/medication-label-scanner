import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/domain/repo/medicine_repository.dart';

@lazySingleton
class WatchMedicinesUsecase implements StreamUseCase<List<Medicine>, NoParams> {
  WatchMedicinesUsecase(this._repo);
  final MedicineRepository _repo;

  @override
  Stream<List<Medicine>> call(NoParams params) => _repo.watchAll();
}
