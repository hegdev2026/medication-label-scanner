import 'package:dartz/dartz.dart';

import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';

abstract interface class MedicineRepository {
  Stream<List<Medicine>> watchAll();
  Stream<Medicine?> watchById(int id);
  Future<Either<Failure, List<Medicine>>> getAll();
  Future<Either<Failure, Medicine?>> getById(int id);

  /// Inserts or updates; returns the stored id.
  Future<Either<Failure, int>> save(Medicine medicine);
  Future<Either<Failure, Unit>> delete(int id);
}
