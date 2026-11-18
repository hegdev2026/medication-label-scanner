import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/features/medicines/domain/entities/form_hints.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_seed.dart';
import 'package:medicine_lab_reader/features/medicines/domain/usecase/get_form_hints_usecase.dart';

part 'form_hints_state.dart';

@injectable
class FormHintsCubit extends Cubit<FormHintsState> {
  FormHintsCubit(this._get) : super(const FormHintsState());
  final GetFormHintsUsecase _get;

  /// Loads suggestions for a searched medicine. Nothing happens without one.
  Future<void> load(MedicineSeed? seed) async {
    if (seed == null) return;
    final result = await _get(seed);
    if (isClosed) return;
    result.fold((_) {}, (h) => emit(FormHintsState(hints: h)));
  }
}
