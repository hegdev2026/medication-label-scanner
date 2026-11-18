import 'package:dartz/dartz.dart';

import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_info.dart';

abstract class MedicineInfoRepository {
  /// Null when there is no reliable match for the name.
  Future<Either<Failure, MedicineInfo?>> findFor({
    required String name,
    String? genericName,
  });

  /// Close spellings of a name RxNorm knows. Empty when none.
  Future<Either<Failure, List<String>>> suggestions(String name);
}
