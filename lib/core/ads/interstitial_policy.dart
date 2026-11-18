/// When a full-screen ad may appear. Deliberately gentle: never on the first
/// events of a session, only every [everyNth] natural break, and never closer
/// together than [minGap].
class InterstitialPolicy {
  InterstitialPolicy({
    this.everyNth = 3,
    this.minGap = const Duration(minutes: 4),
  });
  final int everyNth;
  final Duration minGap;

  int _events = 0;
  DateTime? _lastShown;

  /// Call once per natural break; true when an ad may be shown now.
  bool shouldShow(DateTime now) {
    _events++;
    if (_events % everyNth != 0) return false;
    final last = _lastShown;
    return last == null || now.difference(last) >= minGap;
  }

  void markShown(DateTime now) => _lastShown = now;
}
