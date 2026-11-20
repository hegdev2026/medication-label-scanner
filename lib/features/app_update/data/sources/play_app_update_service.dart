import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart' hide AppUpdateInfo;
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:medicine_lab_reader/features/app_update/domain/entities/app_update_info.dart';
import 'package:medicine_lab_reader/features/app_update/domain/entities/app_update_policy.dart';
import 'package:medicine_lab_reader/features/app_update/domain/services/app_update_service.dart';

/// Play Core updates through the `in_app_update` plugin (Android). It answers
/// only for a copy installed from Google Play; anything else throws.
@LazySingleton(as: AppUpdateService)
class PlayAppUpdateService implements AppUpdateService {
  bool get _supported => !kIsWeb && Platform.isAndroid;

  @override
  Future<AppUpdateInfo?> check() async {
    if (!_supported) return null;
    final info = await InAppUpdate.checkForUpdate();
    final inProgress =
        info.updateAvailability ==
        UpdateAvailability.developerTriggeredUpdateInProgress;
    // An earlier flexible update finished while the app was closed.
    if (inProgress && info.installStatus == InstallStatus.downloaded) {
      return const AppUpdateInfo(
        method: AppUpdateMethod.flexible,
        downloaded: true,
      );
    }
    // An immediate update that was interrupted must be resumed: Play requires
    // it to run to the end.
    if (inProgress && info.immediateUpdateAllowed) {
      return const AppUpdateInfo(
        method: AppUpdateMethod.immediate,
        mandatory: true,
      );
    }
    if (info.updateAvailability != UpdateAvailability.updateAvailable) {
      return null;
    }
    final mandatory = AppUpdatePolicy.isMandatory(
      priority: info.updatePriority,
      stalenessDays: info.clientVersionStalenessDays,
    );
    if (mandatory) {
      // Never leave the person with no way to update: the full-screen flow,
      // else the background download, else Play's page.
      final method = info.immediateUpdateAllowed
          ? AppUpdateMethod.immediate
          : info.flexibleUpdateAllowed
          ? AppUpdateMethod.flexible
          : AppUpdateMethod.store;
      return AppUpdateInfo(method: method, mandatory: true);
    }
    if (!info.flexibleUpdateAllowed) return null;
    return const AppUpdateInfo(method: AppUpdateMethod.flexible);
  }

  @override
  Future<bool> start(AppUpdateMethod method) async => switch (method) {
    AppUpdateMethod.flexible =>
      await InAppUpdate.startFlexibleUpdate() == AppUpdateResult.success,
    AppUpdateMethod.immediate =>
      await InAppUpdate.performImmediateUpdate() == AppUpdateResult.success,
    AppUpdateMethod.store => await _openStore(),
  };

  Future<bool> _openStore() async {
    final app = await PackageInfo.fromPlatform();
    return launchUrl(
      Uri.https('play.google.com', '/store/apps/details', {
        'id': app.packageName,
      }),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Stream<void> get downloaded {
    if (!_supported) return const Stream.empty();
    return InAppUpdate.installUpdateListener
        .where((s) => s == InstallStatus.downloaded)
        .handleError((_) {});
  }

  @override
  Future<void> install() => InAppUpdate.completeFlexibleUpdate();
}
