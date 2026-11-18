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
  AppOpenAd? _appOpen;
  DateTime? _appOpenLoadedAt;
  bool _showing = false;

  /// Google: an App Open ad is stale after 4 hours.
  static const _appOpenLife = Duration(hours: 4);
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
      _loadAppOpen();
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

  @override
  bool get fullScreenShowing => _showing;

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

  void _loadAppOpen() {
    if (!_started || !AdConfig.appOpenOn || _appOpen != null) return;
    AppOpenAd.load(
      adUnitId: AdConfig.appOpen,
      request: _request,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpen = ad;
          _appOpenLoadedAt = DateTime.now();
        },
        onAdFailedToLoad: (_) => _appOpen = null,
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
        _showing = false;
        a.dispose();
        _loadInterstitial();
        if (!done.isCompleted) done.complete(true);
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        _showing = false;
        a.dispose();
        _loadInterstitial();
        if (!done.isCompleted) done.complete(false);
      },
    );
    _showing = true;
    try {
      await ad.show();
    } on Exception {
      _showing = false;
      return false;
    }
    return done.future;
  }

  @override
  Future<bool> showAppOpen() async {
    final loadedAt = _appOpenLoadedAt;
    final stale =
        loadedAt == null || DateTime.now().difference(loadedAt) > _appOpenLife;
    final ad = _appOpen;
    if (ad == null || stale) {
      await ad?.dispose();
      _appOpen = null;
      _loadAppOpen();
      return false;
    }
    _appOpen = null;
    final done = Completer<bool>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        _showing = false;
        a.dispose();
        _loadAppOpen();
        if (!done.isCompleted) done.complete(true);
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        _showing = false;
        a.dispose();
        _loadAppOpen();
        if (!done.isCompleted) done.complete(false);
      },
    );
    _showing = true;
    try {
      await ad.show();
    } on Exception {
      _showing = false;
      return false;
    }
    return done.future;
  }
}
