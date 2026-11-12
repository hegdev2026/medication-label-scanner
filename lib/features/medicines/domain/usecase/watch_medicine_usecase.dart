import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/domain/repo/medicine_repository.dart';

@lazySingleton
class WatchMedicineUsecase implements StreamUseCase<Medicine?, int> {
  WatchMedicineUsecase(this._repo);
  final MedicineRepository _repo;

  @override
  Stream<Medicine?> call(int id) => _repo.watchById(id);
}
