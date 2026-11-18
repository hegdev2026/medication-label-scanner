import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/medicines/data/sources/medicine_info_cache.dart';
import 'package:medicine_lab_reader/features/medicines/data/sources/medlineplus_source.dart';
import 'package:medicine_lab_reader/features/medicines/data/sources/openfda_source.dart';
import 'package:medicine_lab_reader/features/medicines/data/models/medicine_info_model.dart';
import 'package:medicine_lab_reader/features/medicines/data/sources/pubchem_source.dart';
import 'package:medicine_lab_reader/features/medicines/data/sources/rxnorm_source.dart';
import 'package:medicine_lab_reader/features/medicines/data/sources/wikidata_source.dart';
import 'package:medicine_lab_reader/features/medicines/data/sources/wikipedia_source.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_info.dart';
import 'package:medicine_lab_reader/features/medicines/domain/repo/medicine_info_repository.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/medicine_name_query.dart';

/// Combines public sources. First the US drug sources: RxNorm (what is this
/// medicine?), openFDA (label text), DailyMed (pictures) and MedlinePlus (link).
/// If they have nothing, Wikipedia (article, then full-text search) and Wikidata
/// are searched live for whatever was typed, and any hit is sent back through
/// the drug sources by its proper name. PubChem helps with spellings.
@LazySingleton(as: MedicineInfoRepository)
class MedicineInfoRepositoryImpl implements MedicineInfoRepository {
  MedicineInfoRepositoryImpl(
    this._cache,
    this._rxNorm,
    this._openFda,
    this._medlinePlus,
    this._wikipedia,
    this._wikidata,
    this._pubChem,
  );
  final MedicineInfoCache _cache;
  final RxNormSource _rxNorm;
  final OpenFdaSource _openFda;
  final MedlinePlusSource _medlinePlus;
  final WikipediaSource _wikipedia;
  final WikidataSource _wikidata;
  final PubChemSource _pubChem;

  @override
  Future<Either<Failure, MedicineInfo?>> findFor({
    required String name,
    String? genericName,
  }) async {
    try {
      final texts = [genericName, name];
      // 1. US drug sources. The generic name from the label is the most
      //    reliable, then the brand.
      for (final text in texts) {
        final info = await _usSources(text);
        if (info != null) return Right(info);
      }
      // 2. Wikipedia article under the typed name.
      for (final text in texts) {
        final typed = text?.trim() ?? '';
        if (typed.isEmpty) continue;
        final info = await _wikipedia.lookup(typed);
        if (info != null) return Right(await _remember(typed, info));
      }
      // 3. Discovery: search Wikipedia's text and Wikidata for whatever was
      //    typed (a brand, an alias). A hit leads to a name the drug sources
      //    may know; otherwise the article itself is shown.
      for (final text in texts) {
        final typed = text?.trim() ?? '';
        if (typed.isEmpty) continue;
        final info = await _discover(typed);
        if (info != null) return Right(await _remember(typed, info));
      }
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure(detail: '$e'));
    }
  }

  Future<MedicineInfoModel> _remember(
    String typed,
    MedicineInfoModel info,
  ) async {
    final key = MedicineNameQuery.ingredients(typed).join('|');
    if (key.isNotEmpty) await _cache.write(key, info);
    return info;
  }

  /// RxNorm, openFDA, DailyMed and MedlinePlus for one name.
  Future<MedicineInfoModel?> _usSources(String? text) async {
    final typed = MedicineNameQuery.ingredients(text);
    if (typed.isEmpty) return null;
    final key = typed.join('|');
    final cached = _cache.read(key);
    if (cached != null) return cached;

    // RxNorm turns a brand or generic name into its active ingredients.
    final rx = typed.length == 1 ? await _rxNorm.resolve(typed.first) : null;
    final fromRx = MedicineNameQuery.ingredients(rx?.ingredients.join(','));
    final candidates = <List<String>>[
      if (fromRx.isNotEmpty) fromRx,
      if (fromRx.join('|') != key) typed,
    ];

    final rxcui = rx?.rxcui;
    final link = (rxcui != null && fromRx.length <= 1)
        ? await _medlinePlus.pageUrl(rxcui)
        : null;
    for (final ingredients in candidates) {
      final info = await _openFda.lookup(ingredients, moreInfoUrl: link);
      if (info != null) {
        await _cache.write(key, info);
        return info;
      }
    }
    return null;
  }

  /// Wikipedia full-text search and Wikidata for [typed]. Each medicine hit is
  /// sent back through the drug sources by its proper name; the first that has
  /// label data wins, else the first Wikipedia article.
  Future<MedicineInfoModel?> _discover(String typed) async {
    final found = await _wikipedia.search(typed);
    final articles = found.articles;
    final labels = await _wikidata.medicineLabels(typed);
    final names = <String>[
      for (final a in articles) a.title,
      ...found.generics,
      ...labels,
    ];
    final seen = <String>{};
    for (final n in names) {
      if (!seen.add(n.toLowerCase())) continue;
      final info = await _usSources(n);
      if (info != null) return info;
    }
    if (articles.isNotEmpty) return articles.first;
    for (final n in [...found.generics, ...labels]) {
      final article = await _wikipedia.lookup(n, rejectCompanies: true);
      if (article != null) return article;
    }
    return null;
  }

  static List<String> _titles(WikiSearchResult r) => [
    for (final a in r.articles) a.title,
    ...r.generics,
  ];

  @override
  Future<Either<Failure, List<String>>> suggestions(String name) async {
    final all = <String>[
      ...await _rxNorm.suggest(name),
      ...await _pubChem.suggest(name),
      ..._titles(await _wikipedia.search(name)),
    ];
    final seen = <String>{};
    return Right(
      [
        for (final s in all)
          if (seen.add(s.toLowerCase())) s,
      ].take(6).toList(),
    );
  }
}
