import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/constants/app_api.dart';
import 'package:medicine_lab_reader/core/network/dio/dio_client.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/medicine_name_query.dart';

class RxNormMatch {
  const RxNormMatch(this.rxcui, this.ingredients);
  final String rxcui;
  final List<String> ingredients;
}

/// NLM RxNorm: exact (normalised) name to RxCUI and active ingredients.
/// Never fuzzy-matches, so a wrong guess cannot slip in.
@lazySingleton
class RxNormSource {
  RxNormSource(this._client);
  final DioClient _client;

  /// Spelling suggestions for a name; empty when there are none or RxNorm is
  /// unreachable.
  Future<List<String>> suggest(String name) async {
    final out = <String>[];
    try {
      final spelling = await _client.get(
        '${AppApi.rxNorm}/spellingsuggestions.json',
        queryParameters: {'name': name},
      );
      final list =
          spelling.data?['suggestionGroup']?['suggestionList']?['suggestion'];
      if (list is List) out.addAll(list.whereType<String>());

      // Close matches by sound or spelling, for example a mistyped brand.
      final approx = await _client.get(
        '${AppApi.rxNorm}/approximateTerm.json',
        queryParameters: {'term': name, 'maxEntries': 6},
      );
      final candidates = approx.data?['approximateGroup']?['candidate'];
      if (candidates is List) {
        for (final c in candidates.whereType<Map<String, dynamic>>()) {
          final n = c['name'];
          if (n is! String) continue;
          final ingredients = MedicineNameQuery.ingredients(n);
          if (ingredients.length == 1) out.add(ingredients.first);
        }
      }
    } on DioException {
      // Suggestions are optional.
    }
    final seen = <String>{};
    return [
      for (final s in out)
        if (seen.add(s.toLowerCase())) s,
    ].take(5).toList();
  }

  /// Names of the products (generic and branded) containing [ingredient],
  /// such as "acetaminophen 500 MG Oral Tablet". Errors propagate; the caller
  /// treats a failure as "no hints".
  Future<List<String>> productNames(String ingredient) async {
    final res = await _client.get(
      '${AppApi.rxNorm}/drugs.json',
      queryParameters: {'name': ingredient},
    );
    final drugGroup = res.data?['drugGroup'];
    final groups = drugGroup is Map<String, dynamic>
        ? drugGroup['conceptGroup']
        : null;
    if (groups is! List) return const [];
    final out = <String>[];
    for (final g in groups.whereType<Map<String, dynamic>>()) {
      if (g['tty'] != 'SCD' && g['tty'] != 'SBD') continue;
      final props = g['conceptProperties'];
      if (props is! List) continue;
      for (final p in props.whereType<Map<String, dynamic>>()) {
        final n = p['name'];
        if (n is String) out.add(n);
      }
    }
    return out;
  }

  /// Null when RxNorm does not know the name exactly or is unreachable. Other
  /// sources can still answer, so errors are not fatal here.
  Future<RxNormMatch?> resolve(String name) async {
    try {
      final id = await _client.get(
        '${AppApi.rxNorm}/rxcui.json',
        queryParameters: {'name': name, 'search': 1},
      );
      final ids = (id.data?['idGroup']?['rxnormId'] as List<dynamic>?) ?? [];
      if (ids.isEmpty) return null;
      final rxcui = '${ids.first}';

      final related = await _client.get(
        // "+" must stay literal: RxNav reads it as a space between types.
        '${AppApi.rxNorm}/rxcui/$rxcui/related.json?tty=IN+MIN',
      );
      final groups =
          (related.data?['relatedGroup']?['conceptGroup'] as List<dynamic>?) ??
          [];
      final names = <String>[];
      // A multi-ingredient product has a MIN concept listing all of them.
      for (final tty in const ['MIN', 'IN']) {
        for (final g in groups.whereType<Map<String, dynamic>>()) {
          if (g['tty'] != tty) continue;
          for (final c in (g['conceptProperties'] as List<dynamic>? ?? [])) {
            final n = c is Map<String, dynamic> ? c['name'] : null;
            if (n is String) names.add(n);
          }
        }
        if (names.isNotEmpty) break;
      }
      return RxNormMatch(rxcui, names);
    } on DioException {
      return null;
    }
  }
}
