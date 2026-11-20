part of 'app_update_cubit.dart';

enum AppUpdateStatus {
  /// Nothing to show: no newer version, or not checked yet.
  idle,

  /// A newer version is waiting; the person may say Later.
  available,

  /// A newer version that cannot be put off.
  mandatory,

  /// Downloading in the background while the app keeps running.
  downloading,

  /// Downloaded; installing restarts the app.
  downloaded,

  /// The update could not be started. Shown once, then the state moves on.
  failed,

  /// The person said Later; not asked again until something becomes mandatory
  /// or a finished download is waiting.
  dismissed,
}

class AppUpdateState extends Equatable {
  const AppUpdateState({this.status = AppUpdateStatus.idle, this.info});
  final AppUpdateStatus status;
  final AppUpdateInfo? info;

  @override
  List<Object?> get props => [status, info];
}
