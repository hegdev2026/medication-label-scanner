import 'package:medicine_lab_reader/features/medicines/domain/entities/form_hints.dart';

/// Pulls strengths ("500 mg") and dosage forms ("Tablet") out of drug names
/// and label text. Pure logic, one function per kind of source, so a source
/// that fails simply contributes [FormHints.empty].
abstract final class FormHintsParser {
  static final _strength = RegExp(
    r'(\d+(?:\.\d+)?)\s?(mg|mcg|g|iu|meq|%)(?:\s?/\s?(?:\d+(?:\.\d+)?)?\s?(ml|g))?',
    caseSensitive: false,
  );

  static final _forms = <(RegExp, String)>[
    (RegExp(r'tablet', caseSensitive: false), 'Tablet'),
    (RegExp(r'capsule', caseSensitive: false), 'Capsule'),
    (
      RegExp(r'syrup|oral solution|suspension|elixir', caseSensitive: false),
      'Syrup',
    ),
    (RegExp(r'injection|injectable', caseSensitive: false), 'Injection'),
    (RegExp(r'cream', caseSensitive: false), 'Cream'),
    (RegExp(r'ointment', caseSensitive: false), 'Ointment'),
    (RegExp(r'\bgel\b', caseSensitive: false), 'Gel'),
    (RegExp(r'drops|ophthalmic|\botic\b', caseSensitive: false), 'Drops'),
    (RegExp(r'inhal', caseSensitive: false), 'Inhaler'),
    (RegExp(r'spray', caseSensitive: false), 'Spray'),
    (RegExp(r'patch', caseSensitive: false), 'Patch'),
    (RegExp(r'suppositor', caseSensitive: false), 'Suppository'),
    (RegExp(r'powder|granules', caseSensitive: false), 'Powder'),
  ];

  static String? _strengthOf(RegExpMatch m) {
    final value = double.tryParse(m.group(1) ?? '');
    final unit = (m.group(2) ?? '').toLowerCase();
    if (value == null || value <= 0 || value > 5000) return null;
    final per = m.group(3)?.toLowerCase();
    final base = '${m.group(1)} ${unit == 'iu' ? 'IU' : unit}';
    if (per == null) return base;
    return '$base/${per == 'ml' ? 'mL' : per}';
  }

  static List<String> _strengthsIn(String text) => [
    for (final m in _strength.allMatches(text)) ?_strengthOf(m),
  ];

  /// The first dosage form named in [text], or null.
  static String? formIn(String text) {
    final all = _formsIn(text);
    return all.isEmpty ? null : all.first;
  }

  /// The first strength in [text], or null.
  static String? strengthIn(String text) {
    final m = _strength.firstMatch(text);
    return m == null ? null : _strengthOf(m);
  }

  static List<String> _formsIn(String text) => [
    for (final (re, label) in _forms)
      if (re.hasMatch(text)) label,
  ];

  /// RxNorm product names such as "acetaminophen 500 MG Oral Tablet [Brand]".
  /// Only single-ingredient products of [ingredient] count.
  static FormHints fromProductNames(List<String> names, String ingredient) {
    final want = ingredient.toLowerCase();
    final strengths = <String>[];
    final forms = <String>[];
    for (final raw in names) {
      final n = raw.replaceAll(RegExp(r'\[.*?\]'), '').trim();
      if (!n.toLowerCase().startsWith(want) || n.contains(' / ')) continue;
      final m = _strength.firstMatch(n);
      final s = m == null ? null : _strengthOf(m);
      if (s != null) strengths.add(s);
      final f = _formsIn(n);
      if (f.isNotEmpty) forms.add(f.first);
    }
    return FormHints(strengths: strengths, forms: forms);
  }

  /// A label's "dosage forms and strengths" text.
  static FormHints fromLabelText(String text) =>
      FormHints(strengths: _strengthsIn(text), forms: _formsIn(text));

  /// What the user typed, for example "Crocin 500mg tablet".
  static FormHints fromTyped(String text) => fromLabelText(text);

  /// Joins hints from several sources: the most repeated first, no duplicates.
  static FormHints merge(
    Iterable<FormHints> all, {
    int maxStrengths = 6,
    int maxForms = 4,
  }) => FormHints(
    strengths: _ranked(all.expand((h) => h.strengths), maxStrengths),
    forms: _ranked(all.expand((h) => h.forms), maxForms),
  );

  static List<String> _ranked(Iterable<String> items, int max) {
    final counts = <String, int>{};
    for (final i in items) {
      counts[i] = (counts[i] ?? 0) + 1;
    }
    final keys = counts.keys.toList();
    // Stable: equal counts keep first-seen order.
    keys.sort((a, b) => (counts[b] ?? 0).compareTo(counts[a] ?? 0));
    return keys.take(max).toList();
  }
}
