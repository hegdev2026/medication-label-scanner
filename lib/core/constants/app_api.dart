/// Public, free, government-run endpoints. Only a medicine name is ever sent.
class AppApi {
  AppApi._();

  /// U.S. FDA drug labels (openFDA).
  static const String openFdaLabel = 'https://api.fda.gov/drug/label.json';

  /// U.S. National Library of Medicine RxNorm (name to ingredient).
  static const String rxNorm = 'https://rxnav.nlm.nih.gov/REST';

  /// NLM DailyMed (label pictures).
  static const String dailyMed =
      'https://dailymed.nlm.nih.gov/dailymed/services/v2';

  /// NLM MedlinePlus Connect. Used only to find the page to link to.
  static const String medlinePlusConnect =
      'https://connect.medlineplus.gov/service';

  /// Identifies the app to Wikimedia (200 requests/minute instead of 10 for
  /// unidentified clients). Add a contact with `--dart-define=APP_CONTACT=<url
  /// or address>` as Wikimedia asks; nothing personal is built in.
  static const String _contact = String.fromEnvironment('APP_CONTACT');
  static const String userAgent = _contact == ''
      ? 'MedScan/1.0 (Flutter app)'
      : 'MedScan/1.0 ($_contact)';

  /// Wikipedia and Wikidata (free, no key): search and article summaries.
  static const String wikipediaApi = 'https://en.wikipedia.org/w/api.php';
  static const String wikidataApi = 'https://www.wikidata.org/w/api.php';

  /// NCBI PubChem (free, no key): compound name autocomplete.
  static const String pubChemAutocomplete =
      'https://pubchem.ncbi.nlm.nih.gov/rest/autocomplete/compound';

  /// OCR.space online OCR, used by smart scan. Get a free key at
  /// https://ocr.space/ocrapi/freekey and build with
  /// `--dart-define=OCR_SPACE_KEY=<key>`. Empty means smart scan is off and
  /// photos are read on the device only.
  static const String ocrSpaceUrl = 'https://api.ocr.space/parse/image';
  static const String ocrSpaceKey = String.fromEnvironment('OCR_SPACE_KEY');

  static const String sourceNames =
      'U.S. FDA (openFDA), U.S. NLM (RxNorm, MedlinePlus, DailyMed)';
}
