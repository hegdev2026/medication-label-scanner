part of 'cloud_scan_cubit.dart';

class CloudScanState extends Equatable {
  const CloudScanState({required this.available, required this.enabled});

  /// An online OCR key is configured in this build.
  final bool available;
  final bool enabled;

  @override
  List<Object?> get props => [available, enabled];
}
