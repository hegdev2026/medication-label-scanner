part of 'suggestions_cubit.dart';

class SuggestionsState extends Equatable {
  const SuggestionsState({this.names = const []});
  final List<String> names;

  @override
  List<Object?> get props => [names];
}
