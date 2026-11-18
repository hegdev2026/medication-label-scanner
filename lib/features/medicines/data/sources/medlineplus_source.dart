import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/constants/app_api.dart';
import 'package:medicine_lab_reader/core/network/dio/dio_client.dart';

/// NLM MedlinePlus Connect. Its drug text is licensed from a third party, so
/// the text is not copied: only the public page address is used, for a
/// "read more" link.
@lazySingleton
class MedlinePlusSource {
  MedlinePlusSource(this._client);
  final DioClient _client;

  /// RxNorm vocabulary code system used by MedlinePlus Connect.
  static const _rxNormOid = '2.16.840.1.113883.6.88';

  Future<String?> pageUrl(String rxcui) async {
    try {
      final res = await _client.get(
        AppApi.medlinePlusConnect,
        queryParameters: {
          'mainSearchCriteria.v.cs': _rxNormOid,
          'mainSearchCriteria.v.c': rxcui,
          'knowledgeResponseType': 'application/json',
        },
      );
      final entries = (res.data?['feed']?['entry'] as List<dynamic>?) ?? [];
      if (entries.isEmpty) return null;
      final first = entries.first;
      final links = first is Map<String, dynamic> ? first['link'] : null;
      if (links is! List || links.isEmpty) return null;
      final link = links.first;
      final href = link is Map<String, dynamic> ? link['href'] : null;
      if (href is! String) return null;
      final uri = Uri.tryParse(href);
      if (uri == null || uri.host != 'medlineplus.gov') return null;
      return uri
          .replace(queryParameters: const {})
          .toString()
          .replaceAll('?', '');
    } on DioException {
      return null;
    }
  }
}
