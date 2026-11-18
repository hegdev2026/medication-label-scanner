import 'package:flutter_test/flutter_test.dart';

import 'package:medicine_lab_reader/features/medicines/data/sources/wikipedia_source.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/label_text_brief.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/medicine_name_query.dart';

void main() {
  group('MedicineNameQuery', () {
    test('drops strength and form, maps UK names to US', () {
      expect(MedicineNameQuery.ingredients('Paracetamol IP 500 mg Tablets'), [
        'acetaminophen',
      ]);
      expect(MedicineNameQuery.ingredients('Dolo 650'), ['dolo']);
    });

    test('ignores salt and release words', () {
      expect(MedicineNameQuery.ingredients('Atorvastatin Calcium'), [
        'atorvastatin',
      ]);
      expect(MedicineNameQuery.ingredients('Metformin HCl ER 500 mg'), [
        'metformin',
      ]);
    });

    test('splits combinations and sorts them', () {
      expect(MedicineNameQuery.ingredients('Paracetamol + Ibuprofen'), [
        'acetaminophen',
        'ibuprofen',
      ]);
      expect(
        MedicineNameQuery.same(
          MedicineNameQuery.ingredients('ACETAMINOPHEN, IBUPROFEN'),
          MedicineNameQuery.ingredients('Ibuprofen/Paracetamol'),
        ),
        isTrue,
      );
    });

    test('a single ingredient never matches a combination', () {
      expect(
        MedicineNameQuery.same(
          MedicineNameQuery.ingredients('Acetaminophen, Caffeine'),
          MedicineNameQuery.ingredients('Paracetamol'),
        ),
        isFalse,
      );
    });

    test('empty input gives no query', () {
      expect(MedicineNameQuery.ingredients(null), isEmpty);
      expect(MedicineNameQuery.ingredients('  '), isEmpty);
    });
  });

  group('LabelTextBrief', () {
    test('strips headings and references, keeps a few short sentences', () {
      final out = LabelTextBrief.brief([
        [
          '1 INDICATIONS AND USAGE Drug X is indicated for pain (1.1). '
              'It is also used for fever [see Clinical Studies (14)]. '
              'Third sentence here. Fourth sentence here. Fifth sentence here.',
        ],
      ], maxItems: 3);
      expect(out.length, 3);
      expect(out.first, 'Drug X is indicated for pain.');
    });

    test('falls through empty fields and truncates long sentences', () {
      final long = 'Word ' * 100;
      final out = LabelTextBrief.brief([
        null,
        <String>[],
        [long],
      ], maxChars: 50);
      expect(out.single.length, lessThanOrEqualTo(51));
      expect(out.single.endsWith('…'), isTrue);
    });

    test('returns nothing when no field has text', () {
      expect(LabelTextBrief.brief([null, <String>[]]), isEmpty);
    });
  });

  group('WikipediaSource.parse', () {
    Map<String, dynamic> page(String description, String extract) => {
      'type': 'standard',
      'title': 'Thing',
      'description': description,
      'extract': extract,
      'content_urls': {
        'desktop': {'page': 'https://en.wikipedia.org/wiki/Thing'},
      },
    };

    test('accepts an article about a medicine, with credit and link', () {
      final info = WikipediaSource.parse(
        page(
          'Medication for pain and fever',
          'Paracetamol is an analgesic. It is used to treat fever. Third.',
        ),
      );
      expect(info?.summary, contains('analgesic'));
      expect(info?.moreInfoUrl, 'https://en.wikipedia.org/wiki/Thing');
      expect(info?.sourceLabel, contains('CC BY-SA'));
      expect(info?.uses, isEmpty);
    });

    test('rejects a same-named non-medicine such as the saffron pigment', () {
      expect(
        WikipediaSource.parse(
          page(
            'Carotenoid chemical compound',
            'Crocin is a carotenoid found in the flowers of crocus.',
          ),
        ),
        isNull,
      );
    });

    test('rejects disambiguation pages and malformed data', () {
      expect(
        WikipediaSource.parse({
          ...page('drug', 'a drug'),
          'type': 'disambiguation',
        }),
        isNull,
      );
      expect(WikipediaSource.parse(null), isNull);
    });
  });
}
