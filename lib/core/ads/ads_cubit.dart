import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/ads/ad_free_store.dart';
import 'package:medicine_lab_reader/core/ads/ad_service.dart';
import 'package:medicine_lab_reader/core/ads/interstitial_policy.dart';

part 'ads_state.dart';

/// App-wide ad state: whether ads may show, the ad-free time a user earned by
/// watching a rewarded video, and when a full-screen ad is allowed.
@lazySingleton
class AdsCubit extends Cubit<AdsState> {
  AdsCubit(this._service, this._store) : super(const AdsState());

  final AdService _service;
  final AdFreeStore _store;
  final InterstitialPolicy _policy = InterstitialPolicy();
  Timer? _expiry;

  /// How long one rewarded video keeps ads away.
  static const adFreeFor = Duration(hours: 24);

  @visibleForTesting
  DateTime Function() clock = DateTime.now;

  /// Consent, then SDK start. Safe to call without waiting.
  Future<void> start() async {
    final until = _store.read();
    final ready = await _service.start();
    final options = ready && await _service.privacyOptionsRequired;
    if (isClosed) return;
    emit(
      AdsState(
        ready: ready,
        adFreeUntil: until,
        privacyOptionsRequired: options,
      ),
    );
    _scheduleExpiry(until);
  }

  /// A natural break: a medicine was just saved. Maybe shows a full-screen ad.
  Future<void> onMedicineAdded() async {
    final now = clock();
    if (!state.showAds(now) || !_policy.shouldShow(now)) return;
    if (await _service.showInterstitial()) _policy.markShown(clock());
  }

  /// Plays a rewarded video; on success ads are hidden for [adFreeFor].
  Future<bool> watchToRemoveAds() async {
    if (!await _service.showRewarded()) return false;
    final until = clock().add(adFreeFor);
    await _store.write(until);
    if (isClosed) return true;
    emit(state.copyWith(adFreeUntil: until));
    _scheduleExpiry(until);
    return true;
  }

  Future<void> showPrivacyOptions() => _service.showPrivacyOptions();

  /// Re-emits when the ad-free time runs out so ads return without a restart.
  void _scheduleExpiry(DateTime? until) {
    _expiry?.cancel();
    if (until == null) return;
    final wait = until.difference(clock());
    if (wait.isNegative) return;
    _expiry = Timer(wait, () {
      if (isClosed) return;
      emit(
        AdsState(
          ready: state.ready,
          privacyOptionsRequired: state.privacyOptionsRequired,
        ),
      );
    });
  }

  @override
  Future<void> close() {
    _expiry?.cancel();
    return super.close();
  }
}
