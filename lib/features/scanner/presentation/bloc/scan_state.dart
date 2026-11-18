part of 'scan_bloc.dart';

enum ScanStatus { idle, consentNeeded, processing, done, failure }

class ScanState extends Equatable {
  const ScanState({
    this.status = ScanStatus.idle,
    this.draft,
    this.failure,
    this.pendingOrigin,
  });

  final ScanStatus status;
  final ScanDraft? draft;
  final Failure? failure;

  /// Where the photo will come from once the user has answered.
  final ImageOrigin? pendingOrigin;

  @override
  List<Object?> get props => [status, draft, failure, pendingOrigin];
}
