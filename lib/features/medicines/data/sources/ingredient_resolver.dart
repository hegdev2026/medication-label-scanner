import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/features/medicines/data/sources/rxnorm_source.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/medicine_name_query.dart';

/// The active ingredient(s) behind a typed name: the label's generic name,
/// else RxNorm's reading of the name, else the typed name itself, so a failed
/// step still leaves something to use.
@lazySingleton
class IngredientResolver {
  IngredientResolver(this._rxNorm);
  final RxNormSource _rxNorm;

  Future<List<String>> resolve(String name, String? genericName) async {
    final fromGeneric = MedicineNameQuery.ingredients(genericName);
    if (fromGeneric.isNotEmpty) return fromGeneric;
    final typed = MedicineNameQuery.ingredients(name);
    if (typed.length == 1) {
      try {
        final rx = await _rxNorm.resolve(typed.first);
        final resolved = MedicineNameQuery.ingredients(
          rx?.ingredients.join(','),
        );
        if (resolved.isNotEmpty) return resolved;
      } on Exception {
        // Fall back to the typed name.
      }
    }
    return typed;
  }
}
