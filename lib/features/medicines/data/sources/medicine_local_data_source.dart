import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/database/app_database.dart';
import 'package:medicine_lab_reader/features/medicines/data/models/medicine_model.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';

/// Drift/SQLite access for medicines.
@lazySingleton
class MedicineLocalDataSource {
  MedicineLocalDataSource(this._db);
  final AppDatabase _db;

  $MedicinesTableTable get _t => _db.medicinesTable;

  Stream<List<MedicineModel>> watchAll() =>
      (_db.select(_t)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch()
          .map((rows) => rows.map(MedicineModel.fromRow).toList());

  Stream<MedicineModel?> watchById(int id) =>
      (_db.select(_t)..where((t) => t.id.equals(id))).watchSingleOrNull().map(
        (r) => r == null ? null : MedicineModel.fromRow(r),
      );

  Future<List<MedicineModel>> getAll() async =>
      (await _db.select(_t).get()).map(MedicineModel.fromRow).toList();

  Future<MedicineModel?> getById(int id) async {
    final row = await (_db.select(
      _t,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : MedicineModel.fromRow(row);
  }

  Future<int> save(Medicine m) =>
      _db.into(_t).insertOnConflictUpdate(MedicineModel.toCompanion(m));

  Future<void> delete(int id) =>
      (_db.delete(_t)..where((t) => t.id.equals(id))).go();
}
