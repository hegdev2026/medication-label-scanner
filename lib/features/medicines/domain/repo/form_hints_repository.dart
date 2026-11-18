import 'package:dartz/dartz.dart';

import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/form_hints.dart';

abstract class FormHintsRepository {
  /// Suggested strengths and forms for a medicine. A source that fails is
  /// skipped; with none available the hints are simply empty.
  Future<Either<Failure, FormHints>> hintsFor({
    required String name,
    String? genericName,
  });
}
