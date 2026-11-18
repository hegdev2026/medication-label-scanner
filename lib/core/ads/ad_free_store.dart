import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Remembers until when the user has earned an ad-free period.
@lazySingleton
class AdFreeStore {
  AdFreeStore(this._prefs);
  final SharedPreferences _prefs;

  static const _key = 'ads.free_until';

  DateTime? read() {
    final ms = _prefs.getInt(_key);
    return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> write(DateTime until) =>
      _prefs.setInt(_key, until.millisecondsSinceEpoch);
}
