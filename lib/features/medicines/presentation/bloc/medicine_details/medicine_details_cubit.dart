import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/domain/usecase/delete_medicine_usecase.dart';
import 'package:medicine_lab_reader/features/medicines/domain/usecase/watch_medicine_usecase.dart';

part 'medicine_details_state.dart';

@injectable
class MedicineDetailsCubit extends Cubit<MedicineDetailsState> {
  MedicineDetailsCubit(this._watch, this._delete)
    : super(const MedicineDetailsState());

  final WatchMedicineUsecase _watch;
  final DeleteMedicineUsecase _delete;
  StreamSubscription<Medicine?>? _sub;

  void load(int id) {
    _sub?.cancel();
    _sub = _watch(id).listen((m) {
      if (!state.deleted) {
        emit(MedicineDetailsState(loading: false, medicine: m));
      }
    });
  }

  Future<void> delete() async {
    final m = state.medicine;
    if (m == null) return;
    final result = await _delete(m);
    result.fold(
      (f) =>
          emit(MedicineDetailsState(loading: false, medicine: m, failure: f)),
      (_) => emit(const MedicineDetailsState(loading: false, deleted: true)),
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
