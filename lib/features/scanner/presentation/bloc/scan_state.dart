part of 'scan_bloc.dart';

enum ScanStatus { idle, processing, done, failure }

class ScanState extends Equatable {
  const ScanState({this.status = ScanStatus.idle, this.draft, this.failure});

  final ScanStatus status;
  final ScanDraft? draft;
  final Failure? failure;

  @override
  List<Object?> get props => [status, draft, failure];
}
