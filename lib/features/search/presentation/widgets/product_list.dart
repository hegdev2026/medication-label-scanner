import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/common/widgets/app_button.dart';
import 'package:medicine_lab_reader/common/widgets/app_skeleton.dart';
import 'package:medicine_lab_reader/common/widgets/section_card.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/di/sl.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_seed.dart';
import 'package:medicine_lab_reader/features/search/presentation/bloc/products_cubit.dart';
import 'package:medicine_lab_reader/features/search/presentation/widgets/product_row.dart';

/// Every brand and strength the search matches, each with its own add button.
/// Shows nothing when no source has any rows, so the page never says "none"
/// for a medicine that has its own info above.
class ProductList extends StatelessWidget {
  const ProductList({super.key, required this.query, this.genericName});
  final String query;

  /// The proper name the lookup found for [query], when it differs.
  final String? genericName;

  @override
  Widget build(BuildContext context) => BlocProvider(
    key: ValueKey('$query|$genericName'),
    create: (_) =>
        sl<ProductsCubit>()
          ..load(MedicineSeed(name: query, genericName: genericName)),
    child: BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, s) {
        if (s.status == ProductsStatus.loading) {
          return const Padding(
            padding: EdgeInsets.only(bottom: AppSpace.md),
            child: _ProductsSkeleton(),
          );
        }
        if (s.products.isEmpty) return const SizedBox.shrink();
        final shown = s.showAll
            ? s.products
            : s.products.take(ProductsCubit.preview).toList();
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpace.md),
          child: SectionCard(
            title: 'search.products'.tr(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'search.productsNote'.tr(),
                  style: AppText.bodySm.tinted(AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpace.sm),
                for (final p in shown) ProductRow(product: p, query: query),
                if (s.products.length > ProductsCubit.preview)
                  AppButton(
                    label: s.showAll
                        ? 'search.showLess'.tr()
                        : 'search.showAll'.tr(args: ['${s.products.length}']),
                    kind: AppButtonKind.text,
                    onPressed: context.read<ProductsCubit>().toggleAll,
                  ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class _ProductsSkeleton extends StatelessWidget {
  const _ProductsSkeleton();

  @override
  Widget build(BuildContext context) => SkeletonCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Bones.line(120, height: 14),
        const SizedBox(height: AppSpace.md),
        for (var i = 0; i < 3; i++) ...[
          Bones.block(height: 44),
          const SizedBox(height: AppSpace.sm),
        ],
      ],
    ),
  );
}
