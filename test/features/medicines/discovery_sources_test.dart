import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:medicine_lab_reader/core/network/dio/dio_client.dart';
import 'package:medicine_lab_reader/core/network/network_info.dart';
import 'package:medicine_lab_reader/features/medicines/data/sources/pubchem_source.dart';
import 'package:medicine_lab_reader/features/medicines/data/sources/wikidata_source.dart';
import 'package:medicine_lab_reader/features/medicines/data/sources/wikipedia_source.dart';

class _On implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
}

Map<String, dynamic> _page(String title, String description, String extract) =>
    {
      'type': 'standard',
      'title': title,
      'description': description,
      'extract': extract,
    };

void main() {
  test('Wikidata keeps only exact-name medicine items', () {
    final out = WikidataSource.parse({
      'search': [
        {
          'label': 'Pantoprazole',
          'description': 'chemical compound, medication',
          'match': {'type': 'alias', 'text': 'Pantop'},
        },
        {
          'label': 'Almecillin',
          'description': 'medication',
          'match': {'type': 'alias', 'text': 'Volino'},
        },
        {
          'label': 'Dolo',
          'description': 'town in Italy',
          'match': {'text': 'Pantop'},
        },
      ],
    }, 'pantop');
    expect(out, ['Pantoprazole']);
    expect(WikidataSource.parse('nope', 'x'), isEmpty);
  });

  test('PubChem suggestions drop truncations and trim synonyms', () {
    final out = PubChemSource.parse({
      'dictionary_terms': {
        'compound': ['Paracetamol (4-hydroxyacetanilide)', 'Para'],
      },
    }, 'paracetmol');
    expect(out, ['Paracetamol']);
    expect(
      PubChemSource.parse({
        'dictionary_terms': {
          'compound': ['Econor'],
        },
      }, 'econorm'),
      isEmpty,
    );
    expect(PubChemSource.parse(null, 'x'), isEmpty);
  });

  test('Wikipedia search path rejects companies, normal path keeps drugs', () {
    final company = _page(
      'Ipca Laboratories',
      'Indian pharmaceutical company',
      'Ipca is a pharmaceutical company that makes drugs.',
    );
    final drug = _page(
      'Pantoprazole',
      'Medication',
      'Pantoprazole is a medication used to treat stomach acid problems.',
    );
    expect(WikipediaSource.parse(company, rejectCompanies: true), isNull);
    expect(
      WikipediaSource.parse(drug, rejectCompanies: true)?.title,
      'Pantoprazole',
    );
  });

  test('a drug article naming its maker is kept; a company article is not', () {
    final volini = _page(
      'Volini',
      'Pain relief brand',
      'Volini is a brand of pain relief spray and cream sold by Sun Pharma. '
          'It was created by Ranbaxy Laboratories.',
    );
    expect(
      WikipediaSource.parse(volini, rejectCompanies: true)?.title,
      'Volini',
    );
    final co = _page(
      'Sun Pharma',
      'Indian company',
      'Sun Pharma is a company that sells medicines and drugs.',
    );
    expect(WikipediaSource.parse(co, rejectCompanies: true), isNull);
  });

  test(
    'DioClient retries a 429 and then succeeds, never retries when off',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => server.close(force: true));
      var hits = 0;
      server.listen((req) async {
        hits++;
        if (hits == 1) {
          req.response
            ..statusCode = 429
            ..headers.set('retry-after', '1');
        } else {
          req.response
            ..headers.contentType = ContentType.json
            ..write('{"ok":true}');
        }
        await req.response.close();
      });
      final client = DioClient(
        Dio(BaseOptions(validateStatus: (c) => c != null && c < 300)),
        _On(),
      );
      final url = 'http://127.0.0.1:${server.port}/x';
      final res = await client.get(url, retries: 2);
      expect(res.data['ok'], true);
      expect(hits, 2);

      hits = 0;
      await expectLater(client.get(url), throwsA(isA<DioException>()));
      expect(hits, 1);
    },
  );
}
