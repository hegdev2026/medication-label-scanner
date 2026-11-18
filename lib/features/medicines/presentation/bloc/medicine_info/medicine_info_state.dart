part of 'medicine_info_cubit.dart';

enum MedicineInfoStatus { loading, found, notFound, offline }

class MedicineInfoState extends Equatable {
  const MedicineInfoState({
    this.status = MedicineInfoStatus.loading,
    this.info,
  });

  final MedicineInfoStatus status;
  final MedicineInfo? info;

  @override
  List<Object?> get props => [status, info];
}
