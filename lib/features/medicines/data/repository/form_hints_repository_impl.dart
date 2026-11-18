import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/data/sources/ingredient_resolver.dart';
import 'package:medicine_lab_reader/features/medicines/data/sources/openfda_source.dart';
import 'package:medicine_lab_reader/features/medicines/data/sources/rxnorm_source.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/form_hints.dart';
import 'package:medicine_lab_reader/features/medicines/domain/repo/form_hints_repository.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/form_hints_parser.dart';

/// Asks three independent sources at once: RxNorm product names, openFDA label
/// text and the typed name itself. Each is guarded on its own, so one failing
/// (offline, throttled, no match) never costs the hints the others found.
@LazySingleton(as: FormHintsRepository)
class FormHintsRepositoryImpl implements FormHintsRepository {
  FormHintsRepositoryImpl(this._rxNorm, this._openFda, this._resolver);
  final RxNormSource _rxNorm;
  final OpenFdaSource _openFda;
  final IngredientResolver _resolver;

  @override
  Future<Either<Failure, FormHints>> hintsFor({
    required String name,
    String? genericName,
  }) async {
    final ingredients = await _resolver.resolve(name, genericName);
    final results = await Future.wait([
      _guard(() async {
        if (ingredients.length != 1) return FormHints.empty;
        final names = await _rxNorm.productNames(ingredients.first);
        return FormHintsParser.fromProductNames(names, ingredients.first);
      }),
      _guard(() async {
        if (ingredients.length != 1) return FormHints.empty;
        final texts = await _openFda.dosageTexts(ingredients);
        return FormHintsParser.merge(texts.map(FormHintsParser.fromLabelText));
      }),
      _guard(() async => FormHintsParser.fromTyped(name)),
    ]);
    return Right(FormHintsParser.merge(results));
  }

  Future<FormHints> _guard(Future<FormHints> Function() source) async {
    try {
      return await source();
    } on Exception {
      return FormHints.empty;
    }
  }
}
