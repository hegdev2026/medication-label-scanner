import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:medicine_lab_reader/features/medicines/data/models/medicine_info_model.dart';

/// On-device copy of looked-up information, so it shows offline next time.
@lazySingleton
class MedicineInfoCache {
  MedicineInfoCache(this._prefs);
  final SharedPreferences _prefs;

  static const _prefix = 'medicine_info.v4.';

  MedicineInfoModel? read(String key) {
    final raw = _prefs.getString('$_prefix$key');
    if (raw == null) return null;
    try {
      return MedicineInfoModel.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> write(String key, MedicineInfoModel info) =>
      _prefs.setString('$_prefix$key', jsonEncode(info.toJson()));
}
