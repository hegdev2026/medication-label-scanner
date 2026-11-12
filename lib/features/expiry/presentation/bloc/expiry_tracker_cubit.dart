import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/expiry_status.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/check_expiry.dart';
import 'package:medicine_lab_reader/features/medicines/domain/usecase/delete_medicine_usecase.dart';
import 'package:medicine_lab_reader/features/medicines/domain/usecase/watch_medicines_usecase.dart';

part 'expiry_tracker_state.dart';

@injectable
class ExpiryTrackerCubit extends Cubit<ExpiryTrackerState> {
  ExpiryTrackerCubit(this._watch, this._delete)
    : super(const ExpiryTrackerState());
  final WatchMedicinesUsecase _watch;
  final DeleteMedicineUsecase _delete;
  StreamSubscription<List<Medicine>>? _sub;

  /// The statuses the tracker lists, most urgent first. Medicines that are not
  /// near their date are left out.
  static const order = [
    ExpiryStatus.expired,
    ExpiryStatus.within30,
    ExpiryStatus.within60,
    ExpiryStatus.within90,
    ExpiryStatus.none,
  ];

  void start() {
    _sub ??= _watch(const NoParams()).listen((list) {
      final now = DateTime.now();
      final groups = <ExpiryStatus, List<Medicine>>{};
      for (final m in list) {
        final status = CheckExpiry.statusFor(m.expiryDate, now);
        if (!order.contains(status)) continue;
        groups.putIfAbsent(status, () => []).add(m);
      }
      final far = DateTime(9999);
      for (final l in groups.values) {
        l.sort((a, b) => (a.expiryDate ?? far).compareTo(b.expiryDate ?? far));
      }
      emit(state.copyWith(loading: false, groups: groups));
    });
  }

  void setFilter(ExpiryStatus? filter) => emit(
    filter == null
        ? state.copyWith(clearFilter: true)
        : state.copyWith(filter: filter),
  );

  Future<void> delete(Medicine m) async {
    final result = await _delete(m);
    result.fold((f) => emit(state.copyWith(failure: f)), (_) {});
    emit(state.copyWith(clearFailure: true));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
