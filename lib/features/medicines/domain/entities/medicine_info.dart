import 'package:equatable/equatable.dart';

/// Brief general reference text about a medicine, taken from public drug
/// labels. Not specific to the user's package and never a statement that the
/// medicine is safe for them.
class MedicineInfo extends Equatable {
  const MedicineInfo({
    required this.title,
    required this.uses,
    required this.sideEffects,
    required this.safety,
    this.summary = '',
    this.moreInfoUrl,
    this.images = const [],
    this.sourceLabel,
  });

  final String title;

  /// A short plain description. Empty when the source gives only sections.
  final String summary;
  final List<String> uses;
  final List<String> sideEffects;
  final List<String> safety;

  /// Public page with the full, regularly reviewed text (MedlinePlus or
  /// Wikipedia).
  final String? moreInfoUrl;

  /// Package or label pictures from the FDA label (https addresses).
  final List<String> images;

  /// Credit for the text when it is not the default US sources.
  final String? sourceLabel;

  @override
  List<Object?> get props => [
    title,
    summary,
    uses,
    sideEffects,
    safety,
    moreInfoUrl,
    images,
    sourceLabel,
  ];
}
