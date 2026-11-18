import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_info_query.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_info.dart';
import 'package:medicine_lab_reader/features/medicines/domain/repo/medicine_info_repository.dart';

@lazySingleton
class GetMedicineInfoUsecase
    implements UseCase<MedicineInfo?, MedicineInfoQuery> {
  GetMedicineInfoUsecase(this._repo);
  final MedicineInfoRepository _repo;

  @override
  Future<Either<Failure, MedicineInfo?>> call(MedicineInfoQuery params) =>
      _repo.findFor(name: params.name, genericName: params.genericName);
}
