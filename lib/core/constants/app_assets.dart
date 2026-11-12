/// Every asset path used by the app. Never inline a raw asset string.
class AppAssets {
  AppAssets._();

  static const String translationsDir = 'assets/translations';

  /// The full MedScan logo (tile, capsule, name and tagline).
  static const String logo = 'assets/images/logo.png';

  /// Just the scan frame and capsule, for small spots such as the app bar.
  static const String logoMark = 'assets/images/logo_mark.png';
}
