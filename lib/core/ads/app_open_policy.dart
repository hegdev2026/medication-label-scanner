/// When an App Open ad may appear: only after the user was really away
/// ([minAway]) and not more than once per [minGap].
class AppOpenPolicy {
  AppOpenPolicy({
    this.minAway = const Duration(minutes: 3),
    this.minGap = const Duration(minutes: 30),
  });
  final Duration minAway;
  final Duration minGap;

  DateTime? _lastShown;

  bool shouldShow({required DateTime left, required DateTime now}) {
    if (now.difference(left) < minAway) return false;
    final last = _lastShown;
    return last == null || now.difference(last) >= minGap;
  }

  void markShown(DateTime now) => _lastShown = now;
}
