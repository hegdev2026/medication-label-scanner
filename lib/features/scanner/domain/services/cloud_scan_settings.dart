/// Whether photos may be sent to the smart-scan server, and whether the user
/// has agreed. Off until the user says yes.
abstract interface class CloudScanSettings {
  /// An online OCR key is configured in this build.
  bool get available;

  /// Null until the user has been asked.
  bool? get consent;

  Future<void> setConsent({required bool allowed});
}
