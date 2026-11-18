import 'package:equatable/equatable.dart';

/// Values to pre-fill the add form with, for a medicine the user found by
/// searching. Expiry, manufacturing date and batch are never guessed: they stay
/// empty for the user to fill in from the pack.
class MedicineSeed extends Equatable {
  const MedicineSeed({
    required this.name,
    this.genericName,
    this.strength,
    this.dosageForm,
  });
  final String name;
  final String? genericName;

  /// Set only when the user picked one specific product from a list.
  final String? strength;
  final String? dosageForm;

  @override
  List<Object?> get props => [name, genericName, strength, dosageForm];
}
