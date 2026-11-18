/// What, if anything, to show at a natural break (a medicine was just added).
enum AdBreak { none, interstitial }

/// Gentle by design: never on the first breaks, a full-screen ad on every
/// [interstitialEvery]th, and never closer than [minGap].
class BreakPolicy {
  BreakPolicy({
    this.interstitialEvery = 3,
    this.minGap = const Duration(minutes: 4),
  });
  final int interstitialEvery;
  final Duration minGap;

  int _events = 0;
  DateTime? _lastShown;

  /// Call once per natural break.
  AdBreak next(DateTime now) {
    _events++;
    final last = _lastShown;
    if (last != null && now.difference(last) < minGap) return AdBreak.none;
    return _events % interstitialEvery == 0
        ? AdBreak.interstitial
        : AdBreak.none;
  }

  void markShown(DateTime now) => _lastShown = now;
}
