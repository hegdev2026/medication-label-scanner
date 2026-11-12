import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/domain/usecase/find_duplicates_usecase.dart';
import 'package:medicine_lab_reader/features/medicines/domain/usecase/get_medicine_usecase.dart';
import 'package:medicine_lab_reader/features/medicines/domain/usecase/save_medicine_usecase.dart';

part 'medicine_form_state.dart';

@injectable
class MedicineFormCubit extends Cubit<MedicineFormState> {
  MedicineFormCubit(this._save, this._findDuplicates, this._get)
    : super(const MedicineFormState());

  final SaveMedicineUsecase _save;
  final FindDuplicatesUsecase _findDuplicates;
  final GetMedicineUsecase _get;
  Medicine? _pending;

  /// Loads the record to edit, or goes straight to ready for add/review.
  Future<void> load(int? id) async {
    if (id == null) {
      emit(const MedicineFormState(status: FormStatus.ready));
      return;
    }
    final result = await _get(id);
    result.fold(
      (f) => emit(MedicineFormState(status: FormStatus.failure, failure: f)),
      (m) => emit(
        m == null
            ? const MedicineFormState(status: FormStatus.notFound)
            : MedicineFormState(status: FormStatus.ready, existing: m),
      ),
    );
  }

  /// Saves the confirmed record; warns about duplicates first.
  Future<void> submit(Medicine medicine) async {
    final existing = state.existing;
    _pending = medicine;
    emit(MedicineFormState(status: FormStatus.saving, existing: existing));
    final dups = await _findDuplicates(medicine);
    final found = dups.getOrElse(() => const []);
    if (found.isNotEmpty) {
      emit(
        MedicineFormState(
          status: FormStatus.duplicateFound,
          existing: existing,
          duplicates: found,
        ),
      );
      return;
    }
    await _persist(medicine);
  }

  /// The user chose "save anyway" after a duplicate warning.
  Future<void> confirmDuplicate() async {
    final pending = _pending;
    if (pending == null) return;
    emit(
      MedicineFormState(status: FormStatus.saving, existing: state.existing),
    );
    await _persist(pending);
  }

  void dismissDuplicate() => emit(
    MedicineFormState(status: FormStatus.ready, existing: state.existing),
  );

  Future<void> _persist(Medicine medicine) async {
    final result = await _save(medicine);
    result.fold(
      (f) => emit(
        MedicineFormState(
          status: FormStatus.failure,
          existing: state.existing,
          failure: f,
        ),
      ),
      (id) => emit(
        MedicineFormState(
          status: FormStatus.saved,
          existing: state.existing,
          savedId: id,
        ),
      ),
    );
  }
}
