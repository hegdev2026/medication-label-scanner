import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/data/sources/medicine_local_data_source.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/domain/repo/medicine_repository.dart';

@LazySingleton(as: MedicineRepository)
class MedicineRepositoryImpl implements MedicineRepository {
  MedicineRepositoryImpl(this._source);
  final MedicineLocalDataSource _source;

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() run) async {
    try {
      return Right(await run());
    } catch (e) {
      return Left(StorageFailure(detail: '$e'));
    }
  }

  @override
  Stream<List<Medicine>> watchAll() => _source.watchAll();

  @override
  Stream<Medicine?> watchById(int id) => _source.watchById(id);

  @override
  Future<Either<Failure, List<Medicine>>> getAll() =>
      _guard<List<Medicine>>(_source.getAll);

  @override
  Future<Either<Failure, Medicine?>> getById(int id) =>
      _guard<Medicine?>(() => _source.getById(id));

  @override
  Future<Either<Failure, int>> save(Medicine medicine) =>
      _guard(() => _source.save(medicine));

  @override
  Future<Either<Failure, Unit>> delete(int id) => _guard(() async {
    await _source.delete(id);
    return unit;
  });
}
