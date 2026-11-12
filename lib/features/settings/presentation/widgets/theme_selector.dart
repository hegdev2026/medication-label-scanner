import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/common/widgets/section_card.dart';
import 'package:medicine_lab_reader/core/theme/theme_cubit.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) => SectionCard(
    title: 'settings.appearance'.tr(),
    child: BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (a, b) => a.mode != b.mode,
      builder: (context, s) => SegmentedButton<ThemeMode>(
        segments: [
          ButtonSegment(
            value: ThemeMode.system,
            label: Text('settings.system'.tr()),
            icon: const Icon(Icons.brightness_auto),
          ),
          ButtonSegment(
            value: ThemeMode.light,
            label: Text('settings.light'.tr()),
            icon: const Icon(Icons.light_mode),
          ),
          ButtonSegment(
            value: ThemeMode.dark,
            label: Text('settings.dark'.tr()),
            icon: const Icon(Icons.dark_mode),
          ),
        ],
        selected: {s.mode},
        onSelectionChanged: (v) => context.read<ThemeCubit>().setMode(v.first),
      ),
    ),
  );
}
