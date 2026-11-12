/// One heading and paragraph of a legal document; both are translation keys.
class LegalSection {
  const LegalSection(this.titleKey, this.bodyKey);
  final String titleKey;
  final String bodyKey;
}

/// A legal document shown in the app (Terms of Service, Privacy Policy).
class LegalDocument {
  const LegalDocument({
    required this.titleKey,
    required this.introKey,
    required this.sections,
  });
  final String titleKey;
  final String introKey;
  final List<LegalSection> sections;
}
