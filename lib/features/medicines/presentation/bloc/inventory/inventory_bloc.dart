import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/expiry_status.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/check_expiry.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/dosage_category.dart';
import 'package:medicine_lab_reader/features/medicines/domain/usecase/delete_medicine_usecase.dart';
import 'package:medicine_lab_reader/features/medicines/domain/usecase/watch_medicines_usecase.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

@injectable
class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc(this._watch, this._delete) : super(const InventoryState()) {
    on<InventoryStarted>(_onStarted);
    on<InventoryUpdated>(
      (e, emit) => emit(state.copyWith(loading: false, all: e.items)),
    );
    on<InventorySearchChanged>(
      (e, emit) => emit(state.copyWith(query: e.query)),
    );
    on<InventoryFilterChanged>(
      (e, emit) => emit(state.copyWith(filter: e.filter)),
    );
    on<InventoryViewChanged>((e, emit) => emit(state.copyWith(view: e.view)));
    on<InventorySortChanged>((e, emit) => emit(state.copyWith(sort: e.sort)));
    on<InventoryDeleted>(_onDeleted);
  }

  final WatchMedicinesUsecase _watch;
  final DeleteMedicineUsecase _delete;
  StreamSubscription<List<Medicine>>? _sub;

  void _onStarted(InventoryStarted e, Emitter<InventoryState> emit) {
    _sub ??= _watch(const NoParams()).listen((m) => add(InventoryUpdated(m)));
  }

  Future<void> _onDeleted(
    InventoryDeleted e,
    Emitter<InventoryState> emit,
  ) async {
    final result = await _delete(e.medicine);
    result.fold((f) => emit(state.copyWith(failure: f)), (_) {});
    emit(state.copyWith(clearFailure: true));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
