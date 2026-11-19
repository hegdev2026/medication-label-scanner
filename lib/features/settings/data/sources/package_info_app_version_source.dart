import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:medicine_lab_reader/features/settings/domain/services/app_version_source.dart';

/// Reads the version from the installed build (pubspec `version: x.y.z+n`).
@LazySingleton(as: AppVersionSource)
class PackageInfoAppVersionSource implements AppVersionSource {
  @override
  Future<String?> read() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.buildNumber.isEmpty
          ? info.version
          : '${info.version} (${info.buildNumber})';
    } on Exception {
      return null;
    }
  }
}
