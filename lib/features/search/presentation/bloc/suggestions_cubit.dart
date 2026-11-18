import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/features/medicines/domain/usecase/suggest_medicine_names_usecase.dart';

part 'suggestions_state.dart';

@injectable
class SuggestionsCubit extends Cubit<SuggestionsState> {
  SuggestionsCubit(this._suggest) : super(const SuggestionsState());
  final SuggestMedicineNamesUsecase _suggest;

  Future<void> load(String name) async {
    final result = await _suggest(name);
    if (isClosed) return;
    result.fold(
      (_) => emit(const SuggestionsState()),
      (names) => emit(
        SuggestionsState(
          names: names
              .where((n) => n.toLowerCase() != name.trim().toLowerCase())
              .toList(),
        ),
      ),
    );
  }
}
