/// Shrinks long drug-label sections into a few short, readable sentences.
class LabelTextBrief {
  const LabelTextBrief._();

  static final _heading = RegExp(
    r'^\s*(?:\d+(?:\.\d+)*\s+)?(?:indications?\s*(?:and|&)\s*usage|uses?|'
    r'adverse\s+reactions?|warnings?(?:\s+and\s+(?:precautions|cautions))?|'
    r'boxed\s+warning|do\s+not\s+use|ask\s+a\s+doctor(?:\s+or\s+pharmacist)?'
    r'(?:\s+before\s+use\s+if)?|stop\s+use\s+and\s+ask\s+a\s+doctor\s+if)'
    r'\s*:?\s*',
    caseSensitive: false,
  );
  static final _refs = RegExp(
    r'\[[^\]]*\]|\(\s*(?:\d+(?:\.\d+)*(?:,\s*\d+(?:\.\d+)*)*)?\s*\)|[•·]',
  );

  /// Boilerplate that says nothing useful to a lay reader.
  static final _skip = RegExp(
    r'elsewhere|see (?:full )?prescribing|dosages? and durations|'
    r'clinical trials? experience',
    caseSensitive: false,
  );
  static final _sentenceEnd = RegExp(r'(?<=[.!?])\s+(?=[A-Z])');

  /// Picks the first non-empty field from [fields] and returns up to
  /// [maxItems] sentences, each at most [maxChars] long.
  static List<String> brief(
    Iterable<dynamic> fields, {
    int maxItems = 3,
    int maxChars = 200,
  }) {
    for (final field in fields) {
      final text = _first(field);
      if (text.isEmpty) continue;
      final cleaned = text
          .replaceAll(_refs, '')
          .replaceFirst(_heading, '')
          .replaceAll(RegExp(r'\s+'), ' ')
          .replaceAllMapped(RegExp(r'\s+([.,;:])'), (m) => m[1] ?? '')
          .trim();
      final out = <String>[];
      for (final s in cleaned.split(_sentenceEnd)) {
        final sentence = s.trim();
        if (sentence.length < 12 || _skip.hasMatch(sentence)) continue;
        out.add(
          _cut(
            '${sentence[0].toUpperCase()}${sentence.substring(1)}',
            maxChars,
          ),
        );
        if (out.length == maxItems) break;
      }
      if (out.isNotEmpty) return out;
    }
    return const [];
  }

  static String _first(dynamic field) {
    if (field is List && field.isNotEmpty) return '${field.first}';
    if (field is String) return field;
    return '';
  }

  static String _cut(String s, int max) {
    if (s.length <= max) return s;
    final head = s.substring(0, max);
    final space = head.lastIndexOf(' ');
    return '${space > 0 ? head.substring(0, space) : head}…';
  }
}
