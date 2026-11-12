import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/section_card.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) => SectionCard(
    title: 'settings.language'.tr(),
    child: SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'en', label: Text('English')),
        ButtonSegment(value: 'hi', label: Text('हिन्दी')),
      ],
      selected: {context.locale.languageCode},
      onSelectionChanged: (v) => context.setLocale(Locale(v.first)),
    ),
  );
}
