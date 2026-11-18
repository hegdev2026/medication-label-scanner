import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/data/sources/ingredient_resolver.dart';
import 'package:medicine_lab_reader/features/medicines/data/sources/rxnorm_source.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_product.dart';
import 'package:medicine_lab_reader/features/medicines/domain/repo/medicine_products_repository.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/product_name_parser.dart';

/// Lists the products behind a search from RxNorm, asked two ways at once: by
/// the typed name (a brand lists its own strengths) and by the active
/// ingredient it resolves to (a generic lists every strength and brand). Each
/// ask is guarded alone, so one failing leaves the other's rows.
@LazySingleton(as: MedicineProductsRepository)
class MedicineProductsRepositoryImpl implements MedicineProductsRepository {
  MedicineProductsRepositoryImpl(this._rxNorm, this._ingredients);
  final RxNormSource _rxNorm;
  final IngredientResolver _ingredients;

  @override
  Future<Either<Failure, List<MedicineProduct>>> productsFor({
    required String name,
    String? genericName,
  }) async {
    final typed = name.trim();
    if (typed.length < 3) return const Right([]);
    final ingredients = await _ingredients.resolve(typed, genericName);
    final ingredient = ingredients.length == 1 ? ingredients.first : null;
    final results = await Future.wait([
      _rows(typed),
      if (ingredient != null && ingredient.toLowerCase() != typed.toLowerCase())
        _rows(ingredient)
      else
        Future.value(const <MedicineProduct>[]),
    ]);
    // The typed name's own rows (a brand's strengths) win; the ingredient's
    // list is the fallback, and also covers the typed name's query failing.
    final own = results[0];
    return Right(own.isNotEmpty ? own : results[1]);
  }

  /// Parsed, de-duplicated rows for one query; empty when it fails.
  Future<List<MedicineProduct>> _rows(String query) async {
    final names = await _guard(() => _rxNorm.productNames(query));
    return ProductNameParser.distinct([
      for (final n in names) ?ProductNameParser.parse(n),
    ]);
  }

  Future<List<String>> _guard(Future<List<String>> Function() ask) async {
    try {
      return await ask();
    } on Exception {
      return const [];
    }
  }
}
