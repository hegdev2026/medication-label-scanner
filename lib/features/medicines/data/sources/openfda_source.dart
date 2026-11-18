import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/constants/app_api.dart';
import 'package:medicine_lab_reader/core/network/dio/dio_client.dart';
import 'package:medicine_lab_reader/features/medicines/data/models/medicine_info_model.dart';
import 'package:medicine_lab_reader/features/medicines/data/sources/dailymed_source.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/medicine_name_query.dart';

/// U.S. FDA drug labels. Public domain data. Network errors propagate.
@lazySingleton
class OpenFdaSource {
  OpenFdaSource(this._client, this._dailyMed);
  final DioClient _client;
  final DailyMedSource _dailyMed;

  /// Generic name first, then brand name. A label is used only when its
  /// ingredient set equals [ingredients] exactly.
  Future<MedicineInfoModel?> lookup(
    List<String> ingredients, {
    String? moreInfoUrl,
  }) async {
    for (final field in const ['generic_name', 'brand_name']) {
      for (final label in await _search(field, ingredients)) {
        final openfda = label['openfda'];
        if (openfda is! Map<String, dynamic>) continue;
        final names = [
          for (final n in (openfda[field] as List<dynamic>? ?? const [])) '$n',
        ];
        final exact = names.any(
          (n) => MedicineNameQuery.same(
            MedicineNameQuery.ingredients(n),
            ingredients,
          ),
        );
        if (!exact) continue;
        final setId = label['set_id'];
        final info = MedicineInfoModel.fromOpenFda(
          label,
          _title(ingredients),
          moreInfoUrl: moreInfoUrl,
          images: setId is String ? await _dailyMed.images(setId) : const [],
        );
        if (info != null) return info;
      }
    }
    return null;
  }

  /// The "dosage forms and strengths" text of labels whose generic name is
  /// exactly [ingredients]. Errors propagate.
  Future<List<String>> dosageTexts(List<String> ingredients) async {
    final out = <String>[];
    for (final label in await _search('generic_name', ingredients)) {
      final openfda = label['openfda'];
      if (openfda is! Map<String, dynamic>) continue;
      final exact =
          [
            for (final n
                in (openfda['generic_name'] as List<dynamic>? ?? const []))
              '$n',
          ].any(
            (n) => MedicineNameQuery.same(
              MedicineNameQuery.ingredients(n),
              ingredients,
            ),
          );
      if (!exact) continue;
      final text = label['dosage_forms_and_strengths'];
      if (text is List) out.addAll(text.whereType<String>());
    }
    return out;
  }

  Future<List<Map<String, dynamic>>> _search(
    String field,
    List<String> ingredients,
  ) async {
    final search = ingredients.map((i) => 'openfda.$field:"$i"').join('+AND+');
    try {
      // The search string is built by hand: openFDA needs a literal "+AND+".
      final res = await _client.get(
        '${AppApi.openFdaLabel}?search=${Uri.encodeFull(search)}&limit=10',
      );
      final results = res.data?['results'];
      if (results is! List) return const [];
      return results.whereType<Map<String, dynamic>>().toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return const [];
      rethrow;
    }
  }

  static String _title(List<String> ingredients) => ingredients
      .map((i) => i.isEmpty ? i : '${i[0].toUpperCase()}${i.substring(1)}')
      .join(' + ');
}
