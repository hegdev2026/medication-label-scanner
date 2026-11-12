import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/domain/repo/medicine_repository.dart';

/// Finds saved medicines that look like the one being saved.
@lazySingleton
class FindDuplicatesUsecase implements UseCase<List<Medicine>, Medicine> {
  FindDuplicatesUsecase(this._repo);
  final MedicineRepository _repo;

  @override
  Future<Either<Failure, List<Medicine>>> call(Medicine candidate) async {
    String norm(String? s) => (s ?? '').trim().toLowerCase();
    final all = await _repo.getAll();
    return all.map(
      (list) => list.where((m) {
        if (m.id == candidate.id) return false;
        if (norm(m.name) != norm(candidate.name)) return false;
        final a = norm(m.batchNumber), b = norm(candidate.batchNumber);
        if (a.isNotEmpty && b.isNotEmpty) return a == b;
        return norm(m.strength) == norm(candidate.strength);
      }).toList(),
    );
  }
}
