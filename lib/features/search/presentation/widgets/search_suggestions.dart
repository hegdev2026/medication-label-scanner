import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/di/sl.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/search/presentation/bloc/search_cubit.dart';
import 'package:medicine_lab_reader/features/search/presentation/bloc/suggestions_cubit.dart';
import 'package:medicine_lab_reader/features/search/presentation/widgets/search_chip.dart';

/// "Did you mean" chips. The user picks one; nothing is chosen for them.
class SearchSuggestions extends StatelessWidget {
  const SearchSuggestions({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) => BlocProvider(
    key: ValueKey(name),
    create: (_) => sl<SuggestionsCubit>()..load(name),
    child: BlocBuilder<SuggestionsCubit, SuggestionsState>(
      builder: (context, s) {
        if (s.names.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: AppSpace.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'search.didYouMean'.tr(),
                style: AppText.labelMd.tinted(AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpace.sm),
              Wrap(
                spacing: AppSpace.sm,
                runSpacing: AppSpace.sm,
                children: [
                  for (final n in s.names)
                    SearchChip(
                      label: n,
                      onTap: () => context.read<SearchCubit>().submit(n),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}
