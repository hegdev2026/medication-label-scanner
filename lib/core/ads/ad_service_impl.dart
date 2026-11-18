import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/ads/ad_config.dart';
import 'package:medicine_lab_reader/core/ads/ad_service.dart';

/// Google Mobile Ads (AdMob) behind [AdService]. Every call is guarded: ads
/// are a bonus, so a failure here must never reach the user.
@LazySingleton(as: AdService)
class AdServiceImpl implements AdService {
  bool _started = false;
  InterstitialAd? _interstitial;
  RewardedAd? _rewarded;

  static const _request = AdRequest();

  @override
  Future<bool> start() async {
    if (!AdConfig.supported) return false;
    try {
      await _gatherConsent();
      if (!await ConsentInformation.instance.canRequestAds()) return false;
      await MobileAds.instance.updateRequestConfiguration(
        // Medicine app: keep ad content mild.
        RequestConfiguration(maxAdContentRating: MaxAdContentRating.pg),
      );
      await MobileAds.instance.initialize();
      _started = true;
      _loadInterstitial();
      _loadRewarded();
      return true;
    } on Exception catch (e) {
      debugPrint('Ads did not start: $e');
      return false;
    }
  }

  /// Google's User Messaging Platform: shows the consent form only where the
  /// user's region requires it.
  Future<void> _gatherConsent() async {
    final done = Completer<void>();
    void finish() {
      if (!done.isCompleted) done.complete();
    }

    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () => ConsentForm.loadAndShowConsentFormIfRequired((_) => finish()),
      (_) => finish(),
    );
    await done.future.timeout(const Duration(seconds: 30), onTimeout: () {});
  }

  @override
  Future<bool> get privacyOptionsRequired async {
    try {
      return await ConsentInformation.instance
              .getPrivacyOptionsRequirementStatus() ==
          PrivacyOptionsRequirementStatus.required;
    } on Exception {
      return false;
    }
  }

  @override
  Future<void> showPrivacyOptions() async {
    try {
      final done = Completer<void>();
      await ConsentForm.showPrivacyOptionsForm((_) {
        if (!done.isCompleted) done.complete();
      });
      await done.future.timeout(const Duration(minutes: 2), onTimeout: () {});
    } on Exception catch (e) {
      debugPrint('Privacy options failed: $e');
    }
  }

  void _loadInterstitial() {
    if (!_started || !AdConfig.interstitialOn || _interstitial != null) return;
    InterstitialAd.load(
      adUnitId: AdConfig.interstitial,
      request: _request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (_) => _interstitial = null,
      ),
    );
  }

  void _loadRewarded() {
    if (!_started || !AdConfig.rewardedOn || _rewarded != null) return;
    RewardedAd.load(
      adUnitId: AdConfig.rewarded,
      request: _request,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewarded = ad,
        onAdFailedToLoad: (_) => _rewarded = null,
      ),
    );
  }

  @override
  Future<bool> showInterstitial() async {
    final ad = _interstitial;
    if (ad == null) {
      _loadInterstitial();
      return false;
    }
    _interstitial = null;
    final done = Completer<bool>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _loadInterstitial();
        if (!done.isCompleted) done.complete(true);
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        _loadInterstitial();
        if (!done.isCompleted) done.complete(false);
      },
    );
    try {
      await ad.show();
    } on Exception {
      return false;
    }
    return done.future;
  }

  @override
  Future<bool> showRewarded() async {
    final ad = _rewarded;
    if (ad == null) {
      _loadRewarded();
      return false;
    }
    _rewarded = null;
    var earned = false;
    final done = Completer<bool>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _loadRewarded();
        if (!done.isCompleted) done.complete(earned);
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        _loadRewarded();
        if (!done.isCompleted) done.complete(false);
      },
    );
    try {
      await ad.show(onUserEarnedReward: (_, _) => earned = true);
    } on Exception {
      return false;
    }
    return done.future;
  }
}
