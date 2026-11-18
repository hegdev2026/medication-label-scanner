import 'package:equatable/equatable.dart';

/// Strengths and dosage forms seen for a medicine in public drug data. They
/// are only suggestions: the user taps one if it matches their pack.
class FormHints extends Equatable {
  const FormHints({this.strengths = const [], this.forms = const []});
  static const empty = FormHints();

  final List<String> strengths;
  final List<String> forms;

  bool get isEmpty => strengths.isEmpty && forms.isEmpty;

  @override
  List<Object?> get props => [strengths, forms];
}
