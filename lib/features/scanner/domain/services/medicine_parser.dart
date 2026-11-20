import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/features/medicines/domain/value_objects/printed_date.dart';
import 'package:medicine_lab_reader/features/scanner/domain/entities/extracted_details.dart';

/// Rule-based field extraction from OCR text. It only reports what is printed
/// and flags anything uncertain; it never invents or auto-corrects values.
@lazySingleton
class MedicineParser {
  static const _forms = [
    'TABLETS',
    'TABLET',
    'CAPSULES',
    'CAPSULE',
    'SYRUP',
    'SUSPENSION',
    'INJECTION',
    'OINTMENT',
    'CREAM',
    'DROPS',
    'GEL',
    'SOLUTION',
    'LOTION',
    'POWDER',
    'INHALER',
  ];
  static const _ignoreWords = [
    'BATCH',
    'B.NO',
    'LOT',
    'EXP',
    'MFG',
    'MFD',
    'MRP',
    'PRICE',
    'STORE',
    'KEEP',
    'MANUFACTURED',
    'MARKETED',
    'MKTD',
    'LTD',
    'LIMITED',
    'PVT',
    'WARNING',
    'SCHEDULE',
    'PHYSICIAN',
    'DOSAGE',
    'COMPOSITION',
    'EACH',
    'CONTAINS',
    'INCL',
    'TAXES',
    'PROTECT',
    'LIGHT',
    'MOISTURE',
    'CHILDREN',
    'RX',
    'NET',
    'STRIP',
    'REACH',
  ];

  static final _strengthRe = RegExp(
    r'(?<![A-Z0-9.])(\d+(?:\.\d+)?)\s*(MG|MCG|IU|ML|G|%)(?![A-Z])',
  );
  static final _batchRe = RegExp(
    r'(?:BATCH|B\.?\s*NO|LOT)\.?\s*(?:NO\.?|NUMBER|#)?\s*[:\-.]?\s*([A-Z0-9][A-Z0-9\-/]{2,})',
  );
  static final _expLabel = RegExp(
    // Also the usual misreads of "EXP" (EXR, EXD, FXP) and "best before".
    r'(?:EXP(?:IRY)?|EX[RD]|FXP|EXPIRES|USE\s+BEFORE|BEST\s+BEFORE)\.?\s*(?:DATE|DT)?\s*[:\-.]?\s*',
  );
  static final _mfgLabel = RegExp(
    r'(?:MFG|MFD|MANUF(?:ACTURING)?)\.?\s*(?:DATE)?\s*[:\-.]?\s*',
  );
  static final _datePart =
      r'(?:\d{1,2}\s*[/\-.]\s*)?(?:\d{1,2}|[A-Z]{3,9})\.?\s*[/\-.,]?\s*\d{2,4}';
  static final _makerRe = RegExp(
    r'(?:MANUFACTURED|MFD\.?|MFG\.?|MARKETED|MKTD\.?)\s*BY\s*[:\-]?\s*(.*)',
  );
  static final _companyRe = RegExp(
    r'\b(LTD|LIMITED|PVT|PHARMA|PHARMACEUTICALS?|LABORATORIES|LABS)\b',
  );

  ExtractedDetails parse(String raw) {
    final lines = raw
        .split(RegExp(r'[\r\n]+'))
        .map((l) => l.replaceAll(RegExp(r'\s+'), ' ').trim())
        .where((l) => l.isNotEmpty)
        .toList();
    final upper = lines.map((l) => l.toUpperCase()).toList();
    final text = upper.join(' ');
    final flagged = <MedicineField>{};
    final warnings = <ExtractionWarning>[];

    // Strength
    final strengths = <String>[];
    for (final l in upper) {
      if (RegExp(r'MRP|PRICE|NET\s*(?:WT|CONTENT)|₹|RS\.').hasMatch(l)) {
        continue;
      }
      for (final m in _strengthRe.allMatches(l)) {
        final s = '${m.group(1)} ${m.group(2)}';
        if (!strengths.contains(s)) strengths.add(s);
      }
    }
    if (strengths.isEmpty) flagged.add(MedicineField.strength);
    if (strengths.length > 1) {
      flagged.add(MedicineField.strength);
      warnings.add(ExtractionWarning.multipleStrengths);
    }

    // Dosage form
    String? form;
    for (final f in _forms) {
      if (RegExp('\\b$f\\b').hasMatch(text)) {
        form = f[0] + f.substring(1).toLowerCase();
        break;
      }
    }

    // Batch
    final batch = _batchRe.firstMatch(text)?.group(1);
    if (batch == null) flagged.add(MedicineField.batch);

    // Dates
    final expiry = _labelledDate(text, _expLabel);
    final mfg = _labelledDate(text, _mfgLabel);
    if (expiry == null) {
      flagged.add(MedicineField.expiryDate);
      warnings.add(ExtractionWarning.noExpiry);
    } else if (expiry.ambiguous) {
      flagged.add(MedicineField.expiryDate);
      warnings.add(ExtractionWarning.ambiguousExpiry);
    }
    if (mfg == null) flagged.add(MedicineField.mfgDate);
    if (mfg != null && mfg.ambiguous) flagged.add(MedicineField.mfgDate);

    // Manufacturer
    String? maker;
    for (var i = 0; i < upper.length && maker == null; i++) {
      final m = _makerRe.firstMatch(upper[i]);
      final captured = m?.group(1);
      if (captured != null) {
        var v = captured.trim();
        if (v.isEmpty && i + 1 < lines.length) v = lines[i + 1];
        if (v.isNotEmpty) maker = _titleCase(v);
      }
    }
    maker ??= () {
      for (var i = 0; i < upper.length; i++) {
        if (_companyRe.hasMatch(upper[i]) && !_makerRe.hasMatch(upper[i])) {
          return lines[i];
        }
      }
      return null;
    }();
    if (maker == null) flagged.add(MedicineField.manufacturer);

    // Name candidates
    final names = _nameCandidates(lines, upper);
    if (names.isEmpty) {
      flagged.add(MedicineField.name);
      warnings.add(ExtractionWarning.noName);
    } else if (names.length > 1) {
      flagged.add(MedicineField.name);
      warnings.add(ExtractionWarning.multipleNames);
    }

    return ExtractedDetails(
      name: names.isEmpty ? null : names.first,
      nameCandidates: names,
      strength: strengths.isEmpty ? null : strengths.first,
      strengthCandidates: strengths,
      dosageForm: form,
      batchNumber: batch,
      manufacturer: maker,
      manufacturingDate: mfg,
      expiryDate: expiry,
      flagged: flagged,
      warnings: warnings,
    );
  }

  PrintedDate? _labelledDate(String text, RegExp label) {
    for (final m in label.allMatches(text)) {
      final rest = text.substring(m.end);
      final d = RegExp('^$_datePart').firstMatch(rest);
      if (d == null) continue;
      final parsed = PrintedDate.parse(d.group(0));
      if (parsed != null) return parsed;
    }
    return null;
  }

  List<String> _nameCandidates(List<String> lines, List<String> upper) {
    final cut = RegExp(
      '\\b(?:${_forms.join('|')}|IP|BP|USP|\\d+(?:\\.\\d+)?\\s*(?:MG|MCG|IU|ML|G|%))(?![A-Z])',
    );
    final out = <String>[];
    for (var i = 0; i < lines.length; i++) {
      final u = upper[i];
      if (_ignoreWords.any((w) => u.contains(w))) {
        // The line may still start with the name before a label (single-line OCR).
        final label = RegExp(
          r'\b(?:BATCH|B\.?\s*NO|LOT|EXP|MFG|MFD|MRP)\b',
        ).firstMatch(u);
        if (label == null || label.start == 0) continue;
        final head = _prefix(lines[i].substring(0, label.start), cut);
        if (head != null && !out.contains(head)) out.add(head);
        continue;
      }
      final head = _prefix(lines[i], cut);
      if (head != null && !out.contains(head)) out.add(head);
    }
    return out.take(5).toList();
  }

  String? _prefix(String line, RegExp cut) {
    final u = line.toUpperCase();
    final m = cut.firstMatch(u);
    final head = (m == null ? line : line.substring(0, m.start)).trim();
    final clean = head.replaceAll(RegExp(r'[^A-Za-z\- ]'), '').trim();
    if (clean.length < 3 || clean.length > 40) return null;
    final letters = RegExp(r'[A-Za-z]').allMatches(clean).length;
    if (letters < clean.length * 0.7) return null;
    return _titleCase(clean);
  }

  String _titleCase(String s) => s
      .split(' ')
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
      .join(' ');
}
