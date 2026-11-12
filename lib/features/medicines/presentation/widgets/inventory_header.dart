import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/common/widgets/summary_tile.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/bloc/inventory/inventory_bloc.dart';

/// Three compact summary tiles in one row. Saved and Expiring soon double as
/// shortcuts to those filters.
class InventoryHeader extends StatelessWidget {
  const InventoryHeader({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<InventoryBloc, InventoryState>(
        buildWhen: (a, b) => a.all != b.all || a.filter != b.filter,
        builder: (context, s) {
          final bloc = context.read<InventoryBloc>();
          final review = s.all
              .where((m) => m.reviewStatus == ReviewStatus.needsReview)
              .length;
          return Row(
            children: [
              Expanded(
                child: SummaryTile(
                  icon: Icons.medication_outlined,
                  color: AppColors.primary,
                  value: s.all.length,
                  label: 'inventory.statSaved'.tr(),
                  selected: s.filter == InventoryFilter.all,
                  onTap: () => bloc.add(
                    const InventoryFilterChanged(InventoryFilter.all),
                  ),
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              Expanded(
                child: SummaryTile(
                  icon: Icons.alarm,
                  color: AppColors.warning,
                  value: s.countFor(InventoryFilter.expiringSoon),
                  label: 'inventory.statExpiring'.tr(),
                  selected: s.filter == InventoryFilter.expiringSoon,
                  onTap: () => bloc.add(
                    const InventoryFilterChanged(InventoryFilter.expiringSoon),
                  ),
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              Expanded(
                child: SummaryTile(
                  icon: Icons.fact_check_outlined,
                  color: AppColors.danger,
                  value: review,
                  label: 'inventory.statReview'.tr(),
                ),
              ),
            ],
          );
        },
      );
}
