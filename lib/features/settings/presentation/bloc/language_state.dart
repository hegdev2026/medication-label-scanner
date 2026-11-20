part of 'language_cubit.dart';

class LanguageState extends Equatable {
  const LanguageState({this.code = 'en'});

  /// Language code shown as selected.
  final String code;

  @override
  List<Object?> get props => [code];
}
