import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/common/widgets/app_button.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_product.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_seed.dart';

/// One brand-and-strength row with its own add button. The add opens the form
/// with this product's name, strength and form filled in; dates and batch stay
/// for the user to take from their pack.
class ProductRow extends StatelessWidget {
  const ProductRow({super.key, required this.product, required this.query});
  final MedicineProduct product;

  /// What the user typed; kept as the name when the row is a plain generic.
  final String query;

  String get _detail => [
    if (product.brand != null) product.genericName,
    if (product.strength != null) product.strength,
    if (product.form != null) product.form,
  ].whereType<String>().join(' · ');

  MedicineSeed get _seed => MedicineSeed(
    name: product.brand ?? query,
    genericName: product.genericName,
    strength: product.strength,
    dosageForm: product.form,
  );

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpace.xs),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.labelMd.tinted(AppColors.textPrimary),
              ),
              if (_detail.isNotEmpty)
                Text(
                  _detail,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySm.tinted(AppColors.textSecondary),
                ),
            ],
          ),
        ),
        const SizedBox(width: AppSpace.sm),
        AppButton(
          label: 'search.add'.tr(),
          icon: Icons.add,
          kind: AppButtonKind.tonal,
          expand: false,
          onPressed: () => context.push(AppRoutes.medicineNew, extra: _seed),
        ),
      ],
    ),
  );
}
