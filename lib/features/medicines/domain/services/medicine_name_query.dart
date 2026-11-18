/// Turns label text such as "Dolo 650 Tablets IP" or "Paracetamol + Caffeine"
/// into a sorted list of lower-case ingredient/brand names for lookup.
class MedicineNameQuery {
  const MedicineNameQuery._();

  /// Names that differ between Indian/UK labels and US drug labels.
  static const _synonyms = {
    'paracetamol': 'acetaminophen',
    'salbutamol': 'albuterol',
    'adrenaline': 'epinephrine',
    'amoxycillin': 'amoxicillin',
    'frusemide': 'furosemide',
    'lignocaine': 'lidocaine',
    'rifampicin': 'rifampin',
    'cyanocobalamin': 'cyanocobalamin',
    'mecobalamin': 'methylcobalamin',
  };

  static const _ignored = {
    'tablet', 'tablets', 'tab', 'capsule', 'capsules', 'cap', 'caps',
    'syrup', 'suspension', 'injection', 'drops', 'cream', 'gel', 'ointment',
    'ip', 'bp', 'usp', 'mg', 'mcg', 'ml', 'gm', 'g', 'iu', 'hcl',
    // Salts and release types: the active ingredient is what matters.
    'hydrochloride', 'hydrobromide', 'calcium', 'sodium', 'potassium',
    'magnesium', 'maleate', 'tartrate', 'succinate', 'besylate', 'mesylate',
    'sulfate', 'sulphate', 'phosphate', 'citrate', 'acetate', 'fumarate',
    'dihydrate', 'trihydrate', 'monohydrate', 'anhydrous', 'extended',
    'release', 'delayed', 'chewable', 'oral', 'sr', 'xr', 'er', 'cr', 'mr',
  };

  static final _separators = RegExp(r'\s*(?:\+|/|&|,|;|\band\b|\bwith\b)\s*');

  static List<String> ingredients(String? text) {
    if (text == null) return const [];
    final parts = <String>{};
    for (final part in text.toLowerCase().split(_separators)) {
      final words = part
          .split(RegExp(r'[^a-z0-9]+'))
          .where(
            (w) =>
                w.isNotEmpty &&
                !_ignored.contains(w) &&
                !RegExp(r'^\d').hasMatch(w),
          )
          .map((w) => _synonyms[w] ?? w)
          .join(' ');
      if (words.isNotEmpty) parts.add(words);
    }
    return parts.toList()..sort();
  }

  static bool same(List<String> a, List<String> b) =>
      a.isNotEmpty && a.length == b.length && a.toSet().containsAll(b);
}
