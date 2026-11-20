import 'package:medicine_lab_reader/features/app_update/domain/entities/app_update_info.dart';

/// Google Play's in-app update, behind an interface so the flow around it can
/// be tested without Play. Anything that stops it working (a debug build, an
/// APK installed outside Play, no network) throws, and callers treat that as
/// "no update".
abstract interface class AppUpdateService {
  /// What Play offers for this install, or null when this is the newest
  /// version or the update cannot be done in the app.
  Future<AppUpdateInfo?> check();

  /// Runs the update: a flexible one is true once downloading has started
  /// (the person agreed); an immediate one is true if Play took it through.
  /// False when the person turned it down. [AppUpdateMethod.store] opens Play.
  Future<bool> start(AppUpdateMethod method);

  /// Emits once a flexible update has downloaded and is ready to install.
  Stream<void> get downloaded;

  /// Installs the downloaded update; the app restarts.
  Future<void> install();
}
