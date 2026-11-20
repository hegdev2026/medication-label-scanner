import 'package:equatable/equatable.dart';

/// How a newer version gets installed.
enum AppUpdateMethod {
  /// Downloads in the background while the app keeps running (Google Play).
  flexible,

  /// Play's full-screen flow that installs and restarts the app.
  immediate,

  /// Play's own store page, when the in-app update is not possible.
  store,
}

/// A newer version than the one running.
class AppUpdateInfo extends Equatable {
  const AppUpdateInfo({
    required this.method,
    this.mandatory = false,
    this.downloaded = false,
  });

  final AppUpdateMethod method;

  /// Too important to put off (see `AppUpdatePolicy`): it is offered without
  /// "Later", and asked for again every time the app returns to the front.
  final bool mandatory;

  /// Downloaded earlier and only waiting for the app to restart.
  final bool downloaded;

  @override
  List<Object?> get props => [method, mandatory, downloaded];
}
