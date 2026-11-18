import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/constants/app_api.dart';
import 'package:medicine_lab_reader/core/network/dio/dio_client.dart';

/// NLM DailyMed: package and label pictures that come with an FDA label.
@lazySingleton
class DailyMedSource {
  DailyMedSource(this._client);
  final DioClient _client;

  /// Chart, structure and similar figures are not pictures of the medicine.
  static final _notPackage = RegExp(
    r'fig|struct|chart|graph|table|formula|molecul|logo|icon|barcode|curve|'
    r'(?:^|[-_])str(?:[-_.]|$)',
    caseSensitive: false,
  );
  static const _maxImages = 3;

  /// Up to three https picture addresses; empty when none or unreachable.
  Future<List<String>> images(String setId) async {
    try {
      final res = await _client.get(
        '${AppApi.dailyMed}/spls/${Uri.encodeComponent(setId)}/media.json',
      );
      final media = res.data?['data']?['media'];
      if (media is! List) return const [];
      final urls = <String>[];
      for (final m in media.whereType<Map<String, dynamic>>()) {
        final url = m['url'];
        final name = m['name'];
        final type = m['mime_type'];
        if (url is! String || name is! String || type is! String) continue;
        if (!type.startsWith('image/') || _notPackage.hasMatch(name)) continue;
        final uri = Uri.tryParse(url);
        if (uri == null ||
            uri.scheme != 'https' ||
            uri.host != 'dailymed.nlm.nih.gov') {
          continue;
        }
        urls.add(url);
        if (urls.length == _maxImages) break;
      }
      return urls;
    } on DioException {
      return const [];
    }
  }
}
