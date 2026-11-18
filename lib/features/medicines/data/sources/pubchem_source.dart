import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/constants/app_api.dart';
import 'package:medicine_lab_reader/core/network/dio/dio_client.dart';

/// NCBI PubChem name autocomplete (free, public domain). Used only for "did you
/// mean" chips on ingredient and synonym spellings; the user picks one.
@lazySingleton
class PubChemSource {
  PubChemSource(this._client);
  final DioClient _client;

  Future<List<String>> suggest(String term) async {
    final t = term.trim();
    if (t.length < 3) return const [];
    try {
      final res = await _client.get(
        '${AppApi.pubChemAutocomplete}/${Uri.encodeComponent(t)}/json',
        queryParameters: {'limit': 5},
        options: Options(validateStatus: (c) => c != null && c < 500),
      );
      return parse(res.data, t);
    } on Exception {
      return const [];
    }
  }

  static List<String> parse(Object? data, String typed) {
    final dict = data is Map<String, dynamic> ? data['dictionary_terms'] : null;
    final terms = dict is Map<String, dynamic> ? dict['compound'] : null;
    if (terms is! List) return const [];
    final lower = typed.toLowerCase();
    final out = <String>[];
    for (final raw in terms.whereType<String>()) {
      // "Paracetamol (4-hydroxyacetanilide)" -> "Paracetamol".
      final name = raw.replaceAll(RegExp(r'\s*\(.*\)\s*$'), '').trim();
      final n = name.toLowerCase();
      // A shorter prefix of what was typed is a truncation, not a spelling fix.
      if (name.length < 4 || (lower.startsWith(n) && n != lower)) continue;
      if (!out.contains(name)) out.add(name);
    }
    return out;
  }
}
