import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/common/widgets/app_pill.dart';
import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/common/widgets/empty_state.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/dashboard/presentation/widgets/recent_medicine_card.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';

class RecentScansSection extends StatelessWidget {
  const RecentScansSection({
    super.key,
    required this.items,
    required this.total,
    required this.onViewAll,
  });
  final List<Medicine> items;
  final int total;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text('dashboard.recent'.tr(), style: AppText.titleMd),
          const SizedBox(width: AppSpace.sm),
          AppPill(label: '$total', compact: true),
          const Spacer(),
          InkWell(
            onTap: onViewAll,
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpace.sm,
                vertical: AppSpace.sm,
              ),
              child: Text(
                'dashboard.viewAll'.tr(),
                style: AppText.labelMd.tinted(AppColors.accentText),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: AppSpace.sm),
      if (items.isEmpty)
        AppSurface(
          child: EmptyState(
            icon: Icons.document_scanner_outlined,
            title: 'dashboard.emptyTitle'.tr(),
            message: 'dashboard.emptyMsg'.tr(),
          ),
        )
      else
        SizedBox(
          height: 226,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpace.md),
            itemBuilder: (context, i) {
              final m = items[i];
              return SizedBox(
                width: 264,
                child: RecentMedicineCard(
                  medicine: m,
                  onTap: () {
                    final id = m.id;
                    if (id != null) context.push(AppRoutes.details(id));
                  },
                ),
              );
            },
          ),
        ),
    ],
  );
}
