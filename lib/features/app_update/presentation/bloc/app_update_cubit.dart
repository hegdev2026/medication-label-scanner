import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/features/app_update/domain/entities/app_update_info.dart';
import 'package:medicine_lab_reader/features/app_update/domain/services/app_update_service.dart';
import 'package:medicine_lab_reader/features/app_update/domain/usecase/check_app_update_usecase.dart';
import 'package:medicine_lab_reader/features/app_update/domain/usecase/install_app_update_usecase.dart';
import 'package:medicine_lab_reader/features/app_update/domain/usecase/start_app_update_usecase.dart';

part 'app_update_state.dart';

/// "A new version is out": asks Google Play once on opening, offers the update
/// (with Later, unless it is mandatory), downloads it in the background and
/// offers the restart. Asks again when the app returns to the front, but only
/// for what cannot wait: a mandatory update or a finished download.
@lazySingleton
class AppUpdateCubit extends Cubit<AppUpdateState> {
  AppUpdateCubit(this._service, this._check, this._start, this._install)
    : super(const AppUpdateState());

  final AppUpdateService _service;
  final CheckAppUpdateUsecase _check;
  final StartAppUpdateUsecase _start;
  final InstallAppUpdateUsecase _install;

  StreamSubscription<void>? _downloaded;
  bool _checked = false;
  bool _busy = false;
  DateTime? _lastChecked;

  /// The in-app update failed once: from then on "Update" opens Play's page,
  /// so a broken in-app flow never traps the person.
  bool _inAppFailed = false;

  @visibleForTesting
  DateTime Function() clock = DateTime.now;

  /// How long the app may stay open before Play is asked again.
  static const _recheckAfter = Duration(hours: 6);

  bool get _blocking =>
      state.info?.mandatory == true && state.status != AppUpdateStatus.idle;

  /// Once per run. A failed check offers nothing.
  Future<void> check() async {
    if (_checked) return;
    _checked = true;
    await _refresh(escalateOnly: false);
  }

  /// The app came back to the front.
  Future<void> recheck() async {
    if (!_checked || _busy || state.status == AppUpdateStatus.downloading) {
      return;
    }
    final last = _lastChecked;
    final stale = last == null || clock().difference(last) > _recheckAfter;
    final waiting =
        _blocking ||
        state.status == AppUpdateStatus.downloaded ||
        state.status == AppUpdateStatus.dismissed &&
            state.info?.downloaded == true;
    if (!waiting && !stale) return;
    await _refresh(escalateOnly: !_blocking);
  }

  Future<void> _refresh({required bool escalateOnly}) async {
    final result = await _check(const NoParams());
    if (isClosed) return;
    _lastChecked = clock();
    result.fold((_) {}, (info) {
      if (info == null) {
        if (_blocking) emit(const AppUpdateState());
        return;
      }
      // Later is respected unless the update has since become mandatory or has
      // finished downloading.
      if (escalateOnly && !info.mandatory && !info.downloaded) return;
      // The same offer is not announced twice.
      final next = _offer(info);
      if (next != state) emit(next);
    });
  }

  AppUpdateState _offer(AppUpdateInfo info) => AppUpdateState(
    status: info.downloaded
        ? AppUpdateStatus.downloaded
        : info.mandatory
        ? AppUpdateStatus.mandatory
        : AppUpdateStatus.available,
    info: info,
  );

  /// "Update".
  Future<void> update() async {
    final info = state.info;
    if (info == null || _busy) return;
    _busy = true;
    try {
      final method = _inAppFailed ? AppUpdateMethod.store : info.method;
      final flexible = method == AppUpdateMethod.flexible;
      if (flexible) {
        _listenForDownload(info);
        emit(AppUpdateState(status: AppUpdateStatus.downloading, info: info));
      }
      final result = await _start(method);
      if (isClosed) return;
      result.fold(
        (_) {
          if (method != AppUpdateMethod.store) _inAppFailed = true;
          _fail(info);
        },
        (accepted) {
          if (accepted && flexible) return; // keeps downloading
          // Declined, or Play's own flow finished/is restarting the app. A
          // mandatory update stays on offer, an optional one is let go.
          emit(info.mandatory ? _offer(info) : _later(info));
        },
      );
    } finally {
      _busy = false;
    }
  }

  void _listenForDownload(AppUpdateInfo info) {
    _downloaded ??= _service.downloaded.listen((_) {
      if (isClosed) return;
      emit(
        AppUpdateState(
          status: AppUpdateStatus.downloaded,
          info: AppUpdateInfo(
            method: info.method,
            mandatory: info.mandatory,
            downloaded: true,
          ),
        ),
      );
    });
  }

  /// "Restart": installs the downloaded update.
  Future<void> restart() async {
    final info = state.info;
    final result = await _install(const NoParams());
    if (isClosed) return;
    result.fold((_) => _fail(info), (_) {});
  }

  /// "Later". A mandatory update cannot be put off.
  void dismiss() {
    if (_blocking) return;
    final info = state.info;
    emit(info == null ? const AppUpdateState() : _later(info));
  }

  AppUpdateState _later(AppUpdateInfo info) =>
      AppUpdateState(status: AppUpdateStatus.dismissed, info: info);

  /// Tells the person it failed, then goes back to what was on offer.
  void _fail(AppUpdateInfo? info) {
    emit(AppUpdateState(status: AppUpdateStatus.failed, info: info));
    emit(
      info == null
          ? const AppUpdateState()
          : info.mandatory
          ? _offer(info)
          : _later(info),
    );
  }

  @override
  Future<void> close() async {
    await _downloaded?.cancel();
    return super.close();
  }
}
