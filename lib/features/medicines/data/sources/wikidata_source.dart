import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/constants/app_api.dart';
import 'package:medicine_lab_reader/core/network/dio/dio_client.dart';

/// Wikidata entity search (free, CC0). Finds items whose description says they
/// are a medicine, so a brand or alias can lead to a name the drug sources
/// know. Only the typed text is sent.
@lazySingleton
class WikidataSource {
  WikidataSource(this._client);
  final DioClient _client;

  static final _medicine = RegExp(
    r'medication|medicine|drug|antibiotic|analgesic|antipyretic|vitamin|'
    r'pharmaceutical|probiotic|supplement|brand of|therapeutic',
    caseSensitive: false,
  );

  /// Labels of medicine items matching [term]. Possibly empty.
  Future<List<String>> medicineLabels(String term) async {
    if (term.trim().length < 3) return const [];
    try {
      final res = await _client.get(
        AppApi.wikidataApi,
        queryParameters: {
          'action': 'wbsearchentities',
          'search': term.trim(),
          'language': 'en',
          'type': 'item',
          'limit': 8,
          'format': 'json',
        },
        options: Options(headers: {'User-Agent': AppApi.userAgent}),
        retries: 2,
      );
      return parse(res.data, term);
    } on Exception {
      return const [];
    }
  }

  /// Wikidata also matches near spellings, so an item counts only when the
  /// label or alias that matched is exactly what was typed.
  static List<String> parse(Object? data, String typed) {
    final list = data is Map<String, dynamic> ? data['search'] : null;
    if (list is! List) return const [];
    final want = typed.trim().toLowerCase();
    final out = <String>[];
    for (final e in list.whereType<Map<String, dynamic>>()) {
      final label = e['label'];
      final description = e['description'];
      final match = e['match'];
      final text = match is Map<String, dynamic> ? match['text'] : null;
      if (label is! String || description is! String) continue;
      if (!_medicine.hasMatch(description)) continue;
      if (text is! String || text.trim().toLowerCase() != want) continue;
      if (!out.contains(label)) out.add(label);
    }
    return out;
  }
}
