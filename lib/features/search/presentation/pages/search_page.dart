import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/common/widgets/ads/ad_native.dart';
import 'package:medicine_lab_reader/common/widgets/brand_app_bar.dart';
import 'package:medicine_lab_reader/common/widgets/content_wrapper.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/di/sl.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_info.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_info_query.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_info_section.dart';
import 'package:medicine_lab_reader/features/search/presentation/bloc/search_cubit.dart';
import 'package:medicine_lab_reader/features/search/presentation/widgets/add_to_inventory_button.dart';
import 'package:medicine_lab_reader/features/search/presentation/widgets/popular_searches.dart';
import 'package:medicine_lab_reader/features/search/presentation/widgets/product_list.dart';
import 'package:medicine_lab_reader/features/search/presentation/widgets/search_field.dart';
import 'package:medicine_lab_reader/features/search/presentation/widgets/search_suggestions.dart';
import 'package:medicine_lab_reader/features/search/presentation/widgets/web_search_button.dart';

/// Look up any medicine by name, without scanning or saving it.
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  /// The proper name the lookup found, when it differs from what was typed.
  static String? _genericFor(String typed, MedicineInfo? info) {
    final title = info?.title;
    if (title == null || title.toLowerCase() == typed.toLowerCase()) {
      return null;
    }
    return title;
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<SearchCubit>(),
    child: Scaffold(
      appBar: BrandAppBar(title: 'search.title'.tr()),
      body: ContentWrapper(
        scrollable: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SearchField(),
            const SizedBox(height: AppSpace.sm),
            Text(
              'search.tip'.tr(),
              style: AppText.bodySm.tinted(AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpace.lg),
            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, s) => s.query.isEmpty
                  ? const PopularSearches()
                  : Column(
                      children: [
                        MedicineInfoSection(
                          query: MedicineInfoQuery(name: s.query),
                          actionBuilder: (_, info) => Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ProductList(
                                query: s.query,
                                genericName: _genericFor(s.query, info),
                              ),
                              AddToInventoryButton(
                                name: s.query,
                                genericName: _genericFor(s.query, info),
                              ),
                            ],
                          ),
                          notFoundExtra: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SearchSuggestions(name: s.query),
                              WebSearchButton(name: s.query),
                            ],
                          ),
                        ),
                        const AdNative(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    ),
  );
}
