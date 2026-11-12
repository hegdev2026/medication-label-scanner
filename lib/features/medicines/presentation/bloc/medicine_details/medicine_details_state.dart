part of 'medicine_details_cubit.dart';

class MedicineDetailsState extends Equatable {
  const MedicineDetailsState({
    this.loading = true,
    this.medicine,
    this.deleted = false,
    this.failure,
  });

  final bool loading;
  final Medicine? medicine;
  final bool deleted;
  final Failure? failure;

  @override
  List<Object?> get props => [loading, medicine, deleted, failure];
}
