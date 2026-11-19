part of 'app_version_cubit.dart';

class AppVersionState extends Equatable {
  const AppVersionState({this.version});

  /// Null until read, or when it cannot be read.
  final String? version;

  @override
  List<Object?> get props => [version];
}
