import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_info.dart';
import 'package:medicine_lab_reader/features/medicines/domain/services/label_text_brief.dart';

class MedicineInfoModel extends MedicineInfo {
  const MedicineInfoModel({
    required super.title,
    required super.uses,
    required super.sideEffects,
    required super.safety,
    super.summary,
    super.moreInfoUrl,
    super.images,
    super.sourceLabel,
  });

  /// Builds a brief entry from one openFDA label. Null when the label has no
  /// usable "uses" text.
  static MedicineInfoModel? fromOpenFda(
    Map<String, dynamic> label,
    String title, {
    String? moreInfoUrl,
    List<String> images = const [],
  }) {
    final uses = LabelTextBrief.brief([
      label['indications_and_usage'],
      label['purpose'],
    ], maxItems: 2);
    if (uses.isEmpty) return null;
    return MedicineInfoModel(
      title: title,
      moreInfoUrl: moreInfoUrl,
      images: images,
      uses: uses,
      sideEffects: LabelTextBrief.brief([
        label['adverse_reactions'],
        label['stop_use'],
      ], maxItems: 2),
      safety: LabelTextBrief.brief([
        label['boxed_warning'],
        label['warnings_and_cautions'],
        label['warnings'],
        label['do_not_use'],
        label['ask_doctor'],
      ], maxItems: 2),
    );
  }

  factory MedicineInfoModel.fromJson(Map<String, dynamic> json) {
    List<String> list(String key) =>
        (json[key] as List<dynamic>? ?? const []).map((e) => '$e').toList();
    return MedicineInfoModel(
      title: '${json['title']}',
      summary: '${json['summary'] ?? ''}',
      sourceLabel: json['sourceLabel'] as String?,
      uses: list('uses'),
      sideEffects: list('sideEffects'),
      safety: list('safety'),
      moreInfoUrl: json['moreInfoUrl'] as String?,
      images: list('images'),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'summary': summary,
    'sourceLabel': sourceLabel,
    'uses': uses,
    'sideEffects': sideEffects,
    'safety': safety,
    'moreInfoUrl': moreInfoUrl,
    'images': images,
  };
}
