import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/ads/ad_service.dart';
import 'package:medicine_lab_reader/core/ads/app_open_gate.dart';
import 'package:medicine_lab_reader/core/ads/app_open_policy.dart';
import 'package:medicine_lab_reader/core/ads/break_policy.dart';

part 'ads_state.dart';

/// App-wide ad state and rules: whether ads may show, what to show at a
/// natural break, and when an App Open ad may show.
@lazySingleton
class AdsCubit extends Cubit<AdsState> {
  AdsCubit(this._service, this._gate) : super(const AdsState());

  final AdService _service;
  final AppOpenGate _gate;
  final BreakPolicy _breaks = BreakPolicy();
  final AppOpenPolicy _appOpenPolicy = AppOpenPolicy();
  AppLifecycleListener? _lifecycle;
  DateTime? _leftAt;

  @visibleForTesting
  DateTime Function() clock = DateTime.now;

  /// How long to wait after returning to the app before deciding on an App
  /// Open ad, so a reminder tap or a camera return can say "not now" first.
  @visibleForTesting
  Duration resumeDelay = const Duration(seconds: 1);

  /// Consent, then SDK start. Safe to call without waiting.
  Future<void> start() async {
    final ready = await _service.start();
    final options = ready && await _service.privacyOptionsRequired;
    if (isClosed) return;
    emit(AdsState(ready: ready, privacyOptionsRequired: options));
  }

  /// Starts watching the app moving to and from the background, for App Open.
  void observeLifecycle() {
    _lifecycle ??= AppLifecycleListener(
      onStateChange: (s) {
        if (s == AppLifecycleState.paused || s == AppLifecycleState.hidden) {
          onAppLeft();
        } else if (s == AppLifecycleState.resumed) {
          unawaited(onAppResumed());
        }
      },
    );
  }

  /// The app went to the background (not because one of our own ads opened).
  void onAppLeft() {
    if (_service.fullScreenShowing) return;
    _leftAt ??= clock();
  }

  /// The app came back. Maybe shows an App Open ad.
  Future<void> onAppResumed() async {
    final left = _leftAt;
    _leftAt = null;
    await Future<void>.delayed(resumeDelay);
    final now = clock();
    final skip = _gate.consumeSkip(now);
    if (left == null || skip || isClosed) return;
    if (!state.showAds || _service.fullScreenShowing) return;
    if (!_appOpenPolicy.shouldShow(left: left, now: now)) return;
    if (await _service.showAppOpen()) _appOpenPolicy.markShown(clock());
  }

  /// A natural break: a medicine was just added. What should the app show?
  AdBreak nextBreak() {
    if (!state.showAds) return AdBreak.none;
    return _breaks.next(clock());
  }

  Future<void> showInterstitial() async {
    if (await _service.showInterstitial()) _breaks.markShown(clock());
  }

  Future<void> showPrivacyOptions() => _service.showPrivacyOptions();

  @override
  Future<void> close() {
    _lifecycle?.dispose();
    return super.close();
  }
}
