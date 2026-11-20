import 'package:flutter/foundation.dart';

/// Which ad unit each format uses.
///
/// Debug and profile builds always use Google's official TEST ad units, so
/// developing never produces invalid traffic on a real account. Release builds
/// use the real units from `env.json` (`ADMOB_BANNER_ID` and so on); a format
/// with no unit set is simply switched off, so a release can never show test
/// ads by accident or request ads with an empty id.
abstract final class AdConfig {
  static const _banner = String.fromEnvironment('ADMOB_BANNER_ID');
  static const _native = String.fromEnvironment('ADMOB_NATIVE_ID');
  static const _interstitial = String.fromEnvironment('ADMOB_INTERSTITIAL_ID');
  static const _appOpen = String.fromEnvironment('ADMOB_APP_OPEN_ID');

  static const _testDevices = String.fromEnvironment('ADMOB_TEST_DEVICE_IDS');

  /// Devices that get Google test ads even in a release build (comma separated
  /// ids in `ADMOB_TEST_DEVICE_IDS`), so testers on Play's internal track can
  /// tap ads without risking the real account. The ids are in logcat: "Use
  /// RequestConfiguration.Builder().setTestDeviceIds(...)".
  static List<String> get testDeviceIds => [
    for (final id in _testDevices.split(','))
      if (id.trim().isNotEmpty) id.trim(),
  ];

  /// The Google Mobile Ads plugin runs on Android and iOS only.
  static bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  static bool get _android => defaultTargetPlatform == TargetPlatform.android;

  // Google's published sample units: https://developers.google.com/admob/flutter/test-ads
  static String get banner => kReleaseMode
      ? _banner
      : (_android
            ? 'ca-app-pub-3940256099942544/6300978111'
            : 'ca-app-pub-3940256099942544/2934735716');

  static String get native => kReleaseMode
      ? _native
      : (_android
            ? 'ca-app-pub-3940256099942544/2247696110'
            : 'ca-app-pub-3940256099942544/3986624511');

  static String get interstitial => kReleaseMode
      ? _interstitial
      : (_android
            ? 'ca-app-pub-3940256099942544/1033173712'
            : 'ca-app-pub-3940256099942544/4411468910');

  static String get appOpen => kReleaseMode
      ? _appOpen
      : (_android
            ? 'ca-app-pub-3940256099942544/9257395921'
            : 'ca-app-pub-3940256099942544/5575463023');

  static bool get bannerOn => supported && banner.isNotEmpty;
  static bool get nativeOn => supported && native.isNotEmpty;
  static bool get interstitialOn => supported && interstitial.isNotEmpty;
  static bool get appOpenOn => supported && appOpen.isNotEmpty;
}
