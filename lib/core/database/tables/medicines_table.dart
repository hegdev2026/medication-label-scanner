import 'package:drift/drift.dart';

class MedicinesTable extends Table {
  @override
  String get tableName => 'medicines';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get medicineName => text()();
  TextColumn get genericName => text().nullable()();
  TextColumn get strength => text().nullable()();
  TextColumn get dosageForm => text().nullable()();
  TextColumn get batchNumber => text().nullable()();
  TextColumn get manufacturer => text().nullable()();
  DateTimeColumn get manufacturingDate => dateTime().nullable()();
  TextColumn get originalManufacturingText => text().nullable()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  TextColumn get originalExpiryText => text().nullable()();
  TextColumn get imagePath => text().nullable()();
  TextColumn get rawOcrText => text().withDefault(const Constant(''))();
  TextColumn get reviewStatus =>
      text().withDefault(const Constant('confirmed'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
