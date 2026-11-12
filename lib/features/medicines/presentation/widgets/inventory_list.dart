import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/common/adaptive/form_factor.dart';
import 'package:medicine_lab_reader/common/widgets/adaptive_grid.dart';
import 'package:medicine_lab_reader/common/widgets/delete_confirm_dialog.dart';
import 'package:medicine_lab_reader/common/widgets/empty_state.dart';
import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/bloc/inventory/inventory_bloc.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_card.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_card_skeleton.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_grid_card.dart';

/// The filtered medicine cards. Not scrollable itself: the page scrolls.
class InventoryList extends StatelessWidget {
  const InventoryList({super.key});

  Future<void> _confirmDelete(BuildContext context, Medicine m) async {
    final bloc = context.read<InventoryBloc>();
    final ok = await showDeleteConfirmDialog(
      context,
      title: 'inventory.deleteTitle'.tr(args: [m.name]),
      message: 'inventory.deleteMsg'.tr(),
    );
    if (ok) bloc.add(InventoryDeleted(m));
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, s) {
          if (s.loading) {
            return const MedicineListSkeleton();
          }
          final items = s.visible;
          if (items.isEmpty) {
            final noData = s.all.isEmpty;
            return EmptyState(
              icon: Icons.medication_outlined,
              title:
                  (noData ? 'inventory.emptyTitle' : 'inventory.noMatchTitle')
                      .tr(),
              message: (noData ? 'inventory.emptyMsg' : 'inventory.noMatchMsg')
                  .tr(),
            );
          }
          void open(Medicine m) {
            final id = m.id;
            if (id != null) context.push(AppRoutes.details(id));
          }

          void edit(Medicine m) {
            final id = m.id;
            if (id != null) context.push(AppRoutes.edit(id));
          }

          if (s.view == InventoryViewMode.grid) {
            return AdaptiveGrid(
              minItemWidth: context.byFormFactor(mobile: 150.0, tablet: 200.0),
              children: [
                for (final m in items)
                  MedicineGridCard(
                    medicine: m,
                    onTap: () => open(m),
                    onEdit: () => edit(m),
                    onDelete: () => _confirmDelete(context, m),
                  ),
              ],
            );
          }
          final cards = [
            for (final m in items)
              MedicineCard(
                medicine: m,
                onTap: () => open(m),
                onEdit: () => edit(m),
                onDelete: () => _confirmDelete(context, m),
              ),
          ];
          return context.isMobileUi
              ? Column(
                  children: [
                    for (final c in cards)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpace.sm),
                        child: c,
                      ),
                  ],
                )
              : AdaptiveGrid(minItemWidth: 380, children: cards);
        },
      );
}
