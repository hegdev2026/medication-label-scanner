import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/expiry_status.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_card.dart';

/// One status group: a small heading (when [showHeading]) and the same
/// medicine cards the inventory uses.
class ExpirySection extends StatelessWidget {
  const ExpirySection({
    super.key,
    required this.status,
    required this.items,
    required this.onDelete,
    this.showHeading = true,
  });
  final ExpiryStatus status;
  final List<Medicine> items;
  final ValueChanged<Medicine> onDelete;
  final bool showHeading;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (showHeading)
        Padding(
          padding: const EdgeInsets.only(top: AppSpace.xs, bottom: AppSpace.sm),
          child: Text(
            'expiry.section'
                .tr(args: [status.labelKey.tr(), '${items.length}'])
                .toUpperCase(),
            style: AppText.labelMd
                .tinted(AppColors.textSecondary)
                .copyWith(letterSpacing: 1.2),
          ),
        ),
      for (final m in items)
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpace.sm),
          child: MedicineCard(
            medicine: m,
            onTap: () {
              final id = m.id;
              if (id != null) context.push(AppRoutes.details(id));
            },
            onEdit: () {
              final id = m.id;
              if (id != null) context.push(AppRoutes.edit(id));
            },
            onDelete: () => onDelete(m),
          ),
        ),
    ],
  );
}
