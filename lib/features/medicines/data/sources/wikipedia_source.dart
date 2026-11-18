import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/constants/app_api.dart';
import 'package:medicine_lab_reader/core/network/dio/dio_client.dart';
import 'package:medicine_lab_reader/features/medicines/data/models/medicine_info_model.dart';

/// Wikipedia page summaries (text under CC BY-SA 4.0, shown with credit and a
/// link). Used only when the US drug sources have nothing. Looks up the typed
/// name as an article title (redirects followed), never a fuzzy search, and
/// accepts only articles that describe a medicine, so "Crocin" the saffron
/// pigment is not shown as a medicine.
/// Medicine articles found for a typed name, plus generic names taken from
/// "List of X brand names" pages that mention it.
class WikiSearchResult {
  const WikiSearchResult(this.articles, this.generics);
  static const empty = WikiSearchResult([], []);
  final List<MedicineInfoModel> articles;
  final List<String> generics;
}

@lazySingleton
class WikipediaSource {
  WikipediaSource(this._client);
  final DioClient _client;

  static const _summaryUrl =
      'https://en.wikipedia.org/api/rest_v1/page/summary';
  static const credit = 'Wikipedia (CC BY-SA 4.0)';

  static final _medicine = RegExp(
    r'medication|medicine|drug|antibiotic|analgesic|antipyretic|antihistamine|'
    r'anti-?inflammatory|antidiabetic|antihypertensive|probiotic|supplement|'
    r'vitamin|pharmaceutical|used to treat|used for the treatment|'
    r'used to prevent|pain relief|medicated|ointment|topical|tablets?|capsules?|'
    r'syrup',
    caseSensitive: false,
  );

  /// Null when there is no matching medicine article or it is unreachable.
  Future<MedicineInfoModel?> lookup(
    String name, {
    bool rejectCompanies = false,
  }) async {
    final title = name.trim().replaceAll(RegExp(r'\s+'), '_');
    if (title.length < 3) return null;
    try {
      final res = await _client.get(
        '$_summaryUrl/${Uri.encodeComponent(title)}',
        options: Options(headers: _headers),
        retries: 2,
      );
      return parse(res.data, rejectCompanies: rejectCompanies);
    } on Exception {
      return null;
    }
  }

  static const _headers = {'User-Agent': AppApi.userAgent};

  /// An article about a company (not a drug): its description, or the first
  /// sentence "X is a ... company". A drug article that merely names its
  /// maker does not match.
  static final _company = RegExp(
    r'\b(company|corporation|manufacturer|conglomerate|multinational)\b',
    caseSensitive: false,
  );

  static bool _aboutCompany(String? description, String extract) {
    if (description != null && _company.hasMatch(description)) return true;
    final first = extract.split(RegExp(r'(?<=[.!?])\s')).first;
    return RegExp(
          r'\b(is|was) an? [^.]{0,80}',
          caseSensitive: false,
        ).hasMatch(first) &&
        _company.hasMatch(first);
  }

  /// Searches Wikipedia's full text for [term] (a brand or any other name the
  /// user typed) and returns only articles that really describe a medicine AND
  /// whose matching passage contains the typed word. Nothing is a fixed list:
  /// whatever the user types is searched live. Possibly empty.
  Future<WikiSearchResult> search(String term, {int max = 3}) async {
    final clean = term
        .replaceAll(
          RegExp(
            r'\b\d+([.,]\d+)?\s*(mg|mcg|g|ml|iu|%)?',
            caseSensitive: false,
          ),
          ' ',
        )
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (clean.length < 3) return WikiSearchResult.empty;
    final word = RegExp(
      '(^|[^a-z0-9])${RegExp.escape(clean)}([^a-z0-9]|\$)',
      caseSensitive: false,
    );
    final titles = <String>[];
    final generics = <String>[];
    try {
      // The plain phrase, then the phrase with a drug hint: towns and people
      // that share a brand's name rank first otherwise.
      for (final q in ['"$clean"', '"$clean" drug brand name']) {
        final res = await _client.get(
          AppApi.wikipediaApi,
          queryParameters: {
            'action': 'query',
            'list': 'search',
            'srsearch': q,
            'srlimit': 10,
            'srnamespace': 0,
            'format': 'json',
          },
          options: Options(headers: _headers),
          retries: 2,
        );
        final hits = res.data?['query']?['search'];
        if (hits is! List) continue;
        for (final h in hits.whereType<Map<String, dynamic>>()) {
          final t = h['title'];
          final snip = h['snippet'];
          if (t is! String || snip is! String) continue;
          final text = snip.replaceAll(RegExp(r'<[^>]+>'), '');
          final inText = word.hasMatch(text);
          // "List of X brand names" naming the typed brand points to X.
          final list = RegExp(
            r'^List of (.+?) brand names$',
            caseSensitive: false,
          ).firstMatch(t);
          if (list != null) {
            final g = list.group(1) ?? '';
            if (inText && g.isNotEmpty && !generics.contains(g)) {
              generics.add(g);
            }
            continue;
          }
          if (t.startsWith('List of')) continue;
          if (!inText && t.toLowerCase() != clean.toLowerCase()) continue;
          if (!titles.contains(t)) titles.add(t);
        }
      }
    } on Exception {
      return WikiSearchResult.empty;
    }
    if (titles.isEmpty) return WikiSearchResult([], generics);
    final out = <MedicineInfoModel>[];
    // One request for every candidate's intro, in search order.
    final pages = await _intros(titles.take(8).toList());
    for (final t in titles) {
      final info = parse(pages[t], rejectCompanies: true);
      if (info != null) out.add(info);
      if (out.length >= max) break;
    }
    return WikiSearchResult(out, generics);
  }

  /// Intro text and link for [titles] in a single call, shaped like a page
  /// summary so [parse] can read it. Keyed by the requested title.
  Future<Map<String, Map<String, dynamic>>> _intros(List<String> titles) async {
    try {
      final res = await _client.get(
        AppApi.wikipediaApi,
        queryParameters: {
          'action': 'query',
          'prop': 'extracts|description|info',
          'exintro': 1,
          'explaintext': 1,
          'exlimit': 'max',
          'inprop': 'url',
          'redirects': 1,
          'titles': titles.join('|'),
          'format': 'json',
        },
        options: Options(headers: _headers),
        retries: 2,
      );
      final query = res.data?['query'];
      final pages = query is Map<String, dynamic> ? query['pages'] : null;
      if (pages is! Map<String, dynamic>) return const {};
      final out = <String, Map<String, dynamic>>{};
      for (final p in pages.values.whereType<Map<String, dynamic>>()) {
        final title = p['title'];
        if (title is! String) continue;
        out[title] = {
          'type': 'standard',
          'title': title,
          'extract': p['extract'],
          'description': p['description'],
          'content_urls': {
            'desktop': {'page': p['fullurl']},
          },
        };
      }
      return out;
    } on Exception {
      return const {};
    }
  }

  /// Maps a Wikipedia summary to info. Null unless it is a medicine article.
  static MedicineInfoModel? parse(
    Object? data, {
    bool rejectCompanies = false,
  }) {
    if (data is! Map<String, dynamic> || data['type'] != 'standard') {
      return null;
    }
    final title = data['title'];
    final extract = data['extract'];
    final description = data['description'];
    if (title is! String || extract is! String) return null;
    final probe = '${description is String ? description : ''} $extract';
    if (!_medicine.hasMatch(probe)) return null;
    if (rejectCompanies &&
        _aboutCompany(description is String ? description : null, extract)) {
      return null;
    }
    final urls = data['content_urls'];
    final desktop = urls is Map<String, dynamic> ? urls['desktop'] : null;
    final url = desktop is Map<String, dynamic> ? desktop['page'] : null;
    final summary = _firstSentences(extract, 2);
    if (summary.isEmpty) return null;
    return MedicineInfoModel(
      title: title,
      summary: summary,
      uses: const [],
      sideEffects: const [],
      safety: const [],
      moreInfoUrl: url is String && url.startsWith('https://') ? url : null,
      sourceLabel: credit,
    );
  }

  static String _firstSentences(String text, int count) {
    final parts = text.split(RegExp(r'(?<=[.!?])\s+(?=[A-Z])'));
    final out = parts.take(count).join(' ').trim();
    return out.length > 420 ? '${out.substring(0, 417)}…' : out;
  }
}
