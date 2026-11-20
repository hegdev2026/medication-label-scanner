import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/common/widgets/section_card.dart';
import 'package:medicine_lab_reader/core/di/sl.dart';
import 'package:medicine_lab_reader/features/settings/presentation/bloc/language_cubit.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<LanguageCubit>()..sync(context.locale.languageCode),
    child: SectionCard(
      title: 'settings.language'.tr(),
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, s) => SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'en', label: Text('English')),
            ButtonSegment(value: 'hi', label: Text('हिन्दी')),
          ],
          selected: {s.code},
          onSelectionChanged: (v) => context.read<LanguageCubit>().select(
            v.first,
            () => context.setLocale(Locale(v.first)),
          ),
        ),
      ),
    ),
  );
}
