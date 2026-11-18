import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState());

  void submit(String text) => emit(SearchState(query: text.trim()));

  void clear() => emit(const SearchState());
}
