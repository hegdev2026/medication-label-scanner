/// Coarse grouping of the printed dosage form, used only for library filters.
/// It never changes what is stored or shown: an unrecognised form is [other].
enum DosageCategory { tablet, capsule, syrup, topical, other }

abstract final class DosageCategoryResolver {
  // Order matters: "liquid gel" / "softgel" are capsules, not topical gels.
  static final _capsule = RegExp(
    r'\b(capsules?|caps|softgels?|soft\s?gels?|gel\s?caps?|liquid\s?gels?)\b',
    caseSensitive: false,
  );
  static final _tablet = RegExp(
    r'\b(tablets?|tabs?|caplets?|lozenges?)\b',
    caseSensitive: false,
  );
  static final _syrup = RegExp(
    r'\b(syrups?|suspensions?|solutions?|liquids?|drops?|elixirs?|oral\s+liquid)\b',
    caseSensitive: false,
  );
  static final _topical = RegExp(
    r'\b(creams?|ointments?|lotions?|gels?|topical|patch(es)?|sprays?)\b',
    caseSensitive: false,
  );

  static DosageCategory of(String? form) {
    final f = form?.trim() ?? '';
    if (f.isEmpty) return DosageCategory.other;
    if (_capsule.hasMatch(f)) return DosageCategory.capsule;
    if (_tablet.hasMatch(f)) return DosageCategory.tablet;
    if (_syrup.hasMatch(f)) return DosageCategory.syrup;
    if (_topical.hasMatch(f)) return DosageCategory.topical;
    return DosageCategory.other;
  }
}
