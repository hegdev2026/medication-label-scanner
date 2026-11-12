import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_lab_reader/features/settings/domain/services/legal_documents.dart';

/// Every key a legal document points at must exist in both languages, or the
/// page would show a raw key.
void main() {
  for (final lang in ['en', 'hi']) {
    test('$lang has every legal translation key', () {
      final json =
          jsonDecode(File('assets/translations/$lang.json').readAsStringSync())
              as Map<String, dynamic>;
      String? find(String key) {
        Object? node = json;
        for (final part in key.split('.')) {
          if (node is! Map<String, dynamic>) return null;
          node = node[part];
        }
        return node is String && node.trim().isNotEmpty ? node : null;
      }

      for (final doc in [LegalDocuments.terms, LegalDocuments.privacy]) {
        final keys = [
          doc.titleKey,
          doc.introKey,
          for (final s in doc.sections) ...[s.titleKey, s.bodyKey],
        ];
        for (final k in keys) {
          expect(find(k), isNotNull, reason: '$lang is missing $k');
        }
      }
      expect(find('legal.updated'), isNotNull);
      expect(find('legal.settingsTitle'), isNotNull);
    });
  }
}
