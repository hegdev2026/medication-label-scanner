import 'package:equatable/equatable.dart';

/// A date exactly as printed on packaging (e.g. "04/2027", "APR 27").
/// Keeps what was printed separate from the interpretation the app makes.
class PrintedDate extends Equatable {
  const PrintedDate({
    required this.original,
    required this.month,
    required this.year,
    this.day,
    this.ambiguous = false,
  });

  final String original;
  final int month;
  final int year;
  final int? day;

  /// True when the interpretation is uncertain (e.g. two-digit year).
  final bool ambiguous;

  /// Exact day if printed, otherwise the last day of the month.
  DateTime toDateTime() =>
      DateTime(year, month, day ?? DateTime(year, month + 1, 0).day);

  bool get isMonthOnly => day == null;

  @override
  List<Object?> get props => [original, month, year, day, ambiguous];

  static const _months = {
    'JAN': 1,
    'FEB': 2,
    'MAR': 3,
    'APR': 4,
    'MAY': 5,
    'JUN': 6,
    'JUL': 7,
    'AUG': 8,
    'SEP': 9,
    'OCT': 10,
    'NOV': 11,
    'DEC': 12,
  };

  static final _numeric = RegExp(
    r'(?:(\d{1,2})\s*[/\-.]\s*)?(\d{1,2})\s*[/\-.]\s*(\d{4}|\d{2})(?!\d)',
  );
  static final _named = RegExp(
    r'(?:(\d{1,2})\s*[/\-. ]\s*)?'
    r'(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)[A-Z]*\.?\s*[/\-.,]?\s*(\d{4}|\d{2})(?!\d)',
  );

  /// Finds and parses the first date inside [text]. Returns null if none.
  static PrintedDate? parse(String? text) {
    if (text == null) return null;
    final t = text.toUpperCase().trim();
    if (t.isEmpty) return null;

    final named = _named.firstMatch(t);
    if (named != null) {
      final month = _months[named.group(2)];
      final year = named.group(3);
      if (month == null || year == null) return null;
      return _build(
        original: (named.group(0) ?? '').trim(),
        day: int.tryParse(named.group(1) ?? ''),
        month: month,
        yearText: year,
      );
    }
    final m = _numeric.firstMatch(t);
    final month = int.tryParse(m?.group(2) ?? '');
    final year = m?.group(3);
    if (m == null || month == null || year == null) return null;
    return _build(
      original: (m.group(0) ?? '').trim(),
      day: int.tryParse(m.group(1) ?? ''),
      month: month,
      yearText: year,
    );
  }

  static PrintedDate? _build({
    required String original,
    required int? day,
    required int month,
    required String yearText,
  }) {
    if (month < 1 || month > 12) return null;
    final twoDigit = yearText.length == 2;
    final year = twoDigit ? 2000 + int.parse(yearText) : int.parse(yearText);
    if (year < 2000 || year > 2100) return null;
    if (day != null && (day < 1 || day > DateTime(year, month + 1, 0).day)) {
      return null;
    }
    return PrintedDate(
      original: original,
      month: month,
      year: year,
      day: day,
      ambiguous: twoDigit,
    );
  }
}
