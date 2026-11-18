part of 'search_cubit.dart';

class SearchState extends Equatable {
  const SearchState({this.query = ''});

  /// The submitted search; empty before the first search.
  final String query;

  @override
  List<Object?> get props => [query];
}
