import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_product.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_seed.dart';
import 'package:medicine_lab_reader/features/medicines/domain/repo/medicine_products_repository.dart';

@lazySingleton
class GetMedicineProductsUsecase
    implements UseCase<List<MedicineProduct>, MedicineSeed> {
  GetMedicineProductsUsecase(this._repo);
  final MedicineProductsRepository _repo;

  @override
  Future<Either<Failure, List<MedicineProduct>>> call(MedicineSeed seed) =>
      _repo.productsFor(name: seed.name, genericName: seed.genericName);
}
