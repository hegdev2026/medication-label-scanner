part of 'scan_bloc.dart';

sealed class ScanEvent {
  const ScanEvent();
}

class ScanRequested extends ScanEvent {
  const ScanRequested(this.origin);
  final ImageOrigin origin;
}

/// The user's answer to the smart-scan question, then the scan continues.
class ScanConsentAnswered extends ScanEvent {
  const ScanConsentAnswered({required this.allowed, required this.origin});
  final bool allowed;
  final ImageOrigin origin;
}

class ScanReset extends ScanEvent {
  const ScanReset();
}
