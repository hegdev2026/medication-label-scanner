import 'package:dartz/dartz.dart';

import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_product.dart';

abstract class MedicineProductsRepository {
  /// Brands and strengths matching a search. [genericName] is the proper name
  /// the lookup found, when the typed name is a brand the product list does
  /// not know. Empty when no source has any;
  /// a source that fails is skipped.
  Future<Either<Failure, List<MedicineProduct>>> productsFor({
    required String name,
    String? genericName,
  });
}
