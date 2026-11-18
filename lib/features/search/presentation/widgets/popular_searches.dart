import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/common/widgets/empty_state.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/search/presentation/bloc/search_cubit.dart';
import 'package:medicine_lab_reader/features/search/presentation/widgets/search_chip.dart';

/// Starting point before the first search: an intro and common names to tap.
class PopularSearches extends StatelessWidget {
  const PopularSearches({super.key});

  static const _names = [
    'Paracetamol',
    'Ibuprofen',
    'Metformin',
    'Amoxicillin',
    'Azithromycin',
    'Cetirizine',
    'Pantoprazole',
    'Atorvastatin',
    'Amlodipine',
    'Omeprazole',
  ];

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      EmptyState(
        icon: Icons.manage_search,
        title: 'search.emptyTitle'.tr(),
        message: 'search.emptyMsg'.tr(),
      ),
      const SizedBox(height: AppSpace.md),
      Text(
        'search.popular'.tr().toUpperCase(),
        style: AppText.labelMd
            .tinted(AppColors.textSecondary)
            .copyWith(letterSpacing: 1.2),
      ),
      const SizedBox(height: AppSpace.sm),
      Wrap(
        spacing: AppSpace.sm,
        runSpacing: AppSpace.sm,
        children: [
          for (final n in _names)
            SearchChip(
              label: n,
              onTap: () => context.read<SearchCubit>().submit(n),
            ),
        ],
      ),
    ],
  );
}
