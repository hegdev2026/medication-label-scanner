import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:medicine_lab_reader/core/database/tables/medicines_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [MedicinesTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'medscan'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    // Add `onUpgrade` steps here when schemaVersion increases so that
    // existing records survive app updates.
  );
}
