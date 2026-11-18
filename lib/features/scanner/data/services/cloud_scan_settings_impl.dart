import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:medicine_lab_reader/core/constants/app_api.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/cloud_scan_settings.dart';

@LazySingleton(as: CloudScanSettings)
class CloudScanSettingsImpl implements CloudScanSettings {
  CloudScanSettingsImpl(this._prefs);
  final SharedPreferences _prefs;

  static const _key = 'cloud_scan_consent';

  @override
  bool get available => AppApi.ocrSpaceKey.isNotEmpty;

  @override
  bool? get consent => _prefs.getBool(_key);

  @override
  Future<void> setConsent({required bool allowed}) =>
      _prefs.setBool(_key, allowed);
}
