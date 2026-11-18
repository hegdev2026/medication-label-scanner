import 'package:equatable/equatable.dart';

import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';

/// What to look up: a typed search or a saved medicine's name and generic.
class MedicineInfoQuery extends Equatable {
  const MedicineInfoQuery({required this.name, this.genericName});

  factory MedicineInfoQuery.fromMedicine(Medicine m) =>
      MedicineInfoQuery(name: m.name, genericName: m.genericName);

  final String name;
  final String? genericName;

  @override
  List<Object?> get props => [name, genericName];
}
