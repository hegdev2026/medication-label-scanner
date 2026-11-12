part of 'scan_bloc.dart';

sealed class ScanEvent {
  const ScanEvent();
}

class ScanRequested extends ScanEvent {
  const ScanRequested(this.origin);
  final ImageOrigin origin;
}

class ScanReset extends ScanEvent {
  const ScanReset();
}
