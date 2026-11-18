import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_product.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/form_hints_parser.dart';

/// Reads RxNorm product names, for example
/// "acetaminophen 500 MG Oral Tablet [Tylenol]" or
/// "acetaminophen 325 MG / oxycodone hydrochloride 5 MG Oral Tablet".
abstract final class ProductNameParser {
  static final _brand = RegExp(r'\[([^\]]+)\]\s*$');
  // RxNorm puts a volume or duration in front: "100 ML ...", "8 HR ...".
  static final _lead = RegExp(
    r'^\d+(?:\.\d+)?\s*(?:ML|HR)\s+',
    caseSensitive: false,
  );
  static final _part = RegExp(
    r'^(.+?)\s+(\d+(?:\.\d+)?\s?(?:MG|MCG|G|IU|MEQ|%)(?:\s?/\s?(?:\d+(?:\.\d+)?)?\s?(?:ML|G))?)(?![\w/])\s*(.*)$',
    caseSensitive: false,
  );
  static final _modifier = RegExp(
    r'extended[- ]release|delayed[- ]release|chewable|orally disintegrating|'
    r'sustained[- ]release',
    caseSensitive: false,
  );

  /// Null for names that do not fit (packs, kits, no strength).
  static MedicineProduct? parse(String raw) {
    final brand = _brand.firstMatch(raw)?.group(1)?.trim();
    final body = raw.replaceAll(_brand, '').trim();
    if (body.startsWith('{')) return null; // a pack of products
    final parts = body.split(' / ');
    final names = <String>[];
    final strengths = <String>[];
    String tail = '';
    for (var i = 0; i < parts.length; i++) {
      final p = parts[i].replaceFirst(_lead, '');
      final m = _part.firstMatch(p);
      if (m == null) return null;
      names.add(_title(m.group(1) ?? ''));
      final s = FormHintsParser.strengthIn(m.group(2) ?? '');
      if (s == null) return null;
      strengths.add(s);
      if (i == parts.length - 1) tail = m.group(3) ?? '';
    }
    final base = FormHintsParser.formIn(tail);
    final mod = _modifier.firstMatch(tail)?.group(0);
    final form = base == null
        ? null
        : (mod == null ? base : '$base (${_sentence(mod)})');
    return MedicineProduct(
      genericName: names.join(' + '),
      brand: (brand == null || brand.isEmpty) ? null : brand,
      strength: strengths.join(' / '),
      form: form,
      isCombination: names.length > 1,
    );
  }

  /// Distinct products, single-ingredient first, then by strength, generics
  /// before brands.
  static List<MedicineProduct> distinct(
    Iterable<MedicineProduct> all, {
    int max = 100,
  }) {
    final seen = <String>{};
    final out = <MedicineProduct>[
      for (final p in all)
        if (seen.add(
          '${p.brand}|${p.genericName}|${p.strength}|${p.form}'.toLowerCase(),
        ))
          p,
    ];
    double num(MedicineProduct p) =>
        double.tryParse(
          RegExp(r'\d+(\.\d+)?').firstMatch(p.strength ?? '')?.group(0) ?? '',
        ) ??
        0;
    int rank(MedicineProduct p) =>
        (p.isCombination ? 2 : 0) + (p.brand == null ? 0 : 1);
    // Everyday forms first: tablets, capsules and syrups before injections.
    int formRank(MedicineProduct p) {
      final f = (p.form ?? '').toLowerCase();
      for (final (i, k) in const ['tablet', 'capsule', 'syrup'].indexed) {
        if (f.startsWith(k)) return i;
      }
      return 3;
    }

    out.sort((a, b) {
      final r = rank(a).compareTo(rank(b));
      if (r != 0) return r;
      final f = formRank(a).compareTo(formRank(b));
      if (f != 0) return f;
      final t = a.title.toLowerCase().compareTo(b.title.toLowerCase());
      return t != 0 ? t : num(a).compareTo(num(b));
    });
    return out.take(max).toList();
  }

  static String _title(String s) => s
      .trim()
      .split(RegExp(r'\s+'))
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  static String _sentence(String s) {
    final t = s.toLowerCase().replaceAll('-', ' ');
    return '${t[0].toUpperCase()}${t.substring(1)}';
  }
}
