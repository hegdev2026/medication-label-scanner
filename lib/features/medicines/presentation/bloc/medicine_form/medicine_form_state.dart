part of 'medicine_form_cubit.dart';

enum FormStatus {
  loading,
  ready,
  notFound,
  saving,
  duplicateFound,
  saved,
  failure,
}

class MedicineFormState extends Equatable {
  const MedicineFormState({
    this.status = FormStatus.loading,
    this.existing,
    this.duplicates = const [],
    this.savedId,
    this.failure,
  });

  final FormStatus status;

  /// The record being edited; null when adding or reviewing a scan.
  final Medicine? existing;
  final List<Medicine> duplicates;
  final int? savedId;
  final Failure? failure;

  @override
  List<Object?> get props => [status, existing, duplicates, savedId, failure];
}
