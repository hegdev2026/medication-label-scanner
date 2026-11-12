import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/expiry_status.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/check_expiry.dart';
import 'package:medicine_lab_reader/features/medicines/domain/usecase/watch_medicines_usecase.dart';

part 'dashboard_state.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._watch) : super(const DashboardState());
  final WatchMedicinesUsecase _watch;
  StreamSubscription<List<Medicine>>? _sub;

  void start() {
    _sub ??= _watch(const NoParams()).listen((list) {
      final now = DateTime.now();
      var expired = 0, soon = 0;
      for (final m in list) {
        final s = CheckExpiry.statusFor(m.expiryDate, now);
        if (s == ExpiryStatus.expired) expired++;
        if (s == ExpiryStatus.within30) soon++;
      }
      emit(
        state.copyWith(
          loading: false,
          total: list.length,
          expired: expired,
          expiringSoon: soon,
          recent: list.take(5).toList(), // newest first
        ),
      );
    });
  }

  void dismissInfo() => emit(state.copyWith(infoDismissed: true));

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
