import 'package:equatable/equatable.dart';

/// One concrete product a search can match: a brand or generic with a single
/// strength and form, for example "Tylenol 500 mg Tablet".
class MedicineProduct extends Equatable {
  const MedicineProduct({
    required this.genericName,
    this.brand,
    this.strength,
    this.form,
    this.isCombination = false,
  });

  /// Active ingredient(s), for example "Acetaminophen" or
  /// "Acetaminophen + Oxycodone Hydrochloride".
  final String genericName;
  final String? brand;
  final String? strength;
  final String? form;

  /// More than one active ingredient.
  final bool isCombination;

  /// What the list shows as the title.
  String get title => brand ?? genericName;

  @override
  List<Object?> get props => [genericName, brand, strength, form];
}
