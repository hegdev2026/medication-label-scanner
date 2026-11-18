part of 'form_hints_cubit.dart';

class FormHintsState extends Equatable {
  const FormHintsState({this.hints = FormHints.empty});
  final FormHints hints;

  @override
  List<Object?> get props => [hints];
}
