import 'package:injectable/injectable.dart';

/// Tells the App Open ad when NOT to appear. Returning to the app is not
/// always "opening" it: coming back from the camera, the gallery, a browser or
/// a reminder notification must never be met with an ad.
@lazySingleton
class AppOpenGate {
  bool _skipNext = false;
  DateTime? _holdUntil;

  /// Call just before leaving on purpose (camera, gallery, a web link): the
  /// next return to the app shows no App Open ad.
  void leavingTemporarily() => _skipNext = true;

  /// Call when a reminder notification is tapped: for [duration] no App Open
  /// ad is shown, so the user lands straight on what they came for.
  void holdFor(Duration duration, DateTime now) =>
      _holdUntil = now.add(duration);

  /// Asked once per return to the app. True when no ad may be shown.
  bool consumeSkip(DateTime now) {
    final skip = _skipNext;
    _skipNext = false;
    final until = _holdUntil;
    return skip || (until != null && now.isBefore(until));
  }
}
