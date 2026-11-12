import 'package:medicine_lab_reader/features/settings/domain/entities/legal_document.dart';

/// The app's legal documents. The wording lives in the translation files
/// (`legal.*`); this only says which keys make up each document, in order.
abstract final class LegalDocuments {
  /// Bump when either document changes in substance.
  static final DateTime lastUpdated = DateTime(2026, 11, 12);

  static final LegalDocument terms = LegalDocument(
    titleKey: 'legal.termsTitle',
    introKey: 'legal.termsIntro',
    sections: [for (var i = 1; i <= 11; i++) _section('terms', i)],
  );

  static final LegalDocument privacy = LegalDocument(
    titleKey: 'legal.privacyTitle',
    introKey: 'legal.privacyIntro',
    sections: [for (var i = 1; i <= 11; i++) _section('privacy', i)],
  );

  static LegalSection _section(String doc, int n) =>
      LegalSection('legal.$doc.s${n}t', 'legal.$doc.s${n}b');
}
