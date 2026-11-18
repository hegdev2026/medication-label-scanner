import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_info.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_info_query.dart';
import 'package:medicine_lab_reader/features/medicines/domain/usecase/get_medicine_info_usecase.dart';

part 'medicine_info_state.dart';

@injectable
class MedicineInfoCubit extends Cubit<MedicineInfoState> {
  MedicineInfoCubit(this._get) : super(const MedicineInfoState());
  final GetMedicineInfoUsecase _get;

  Future<void> load(MedicineInfoQuery query) async {
    emit(const MedicineInfoState());
    final result = await _get(query);
    if (isClosed) return;
    emit(
      result.fold(
        (_) => const MedicineInfoState(status: MedicineInfoStatus.offline),
        (info) => info == null
            ? const MedicineInfoState(status: MedicineInfoStatus.notFound)
            : MedicineInfoState(status: MedicineInfoStatus.found, info: info),
      ),
    );
  }
}
