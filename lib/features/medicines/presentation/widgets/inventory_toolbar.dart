import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/bloc/inventory/inventory_bloc.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/inventory_sort_sheet.dart';

/// "SORT BY: Recently scanned ▾" on the left, grid/list switch on the right.
class InventoryToolbar extends StatelessWidget {
  const InventoryToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<InventoryBloc>();
    return BlocBuilder<InventoryBloc, InventoryState>(
      buildWhen: (a, b) => a.sort != b.sort || a.view != b.view,
      builder: (context, s) => Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.full),
              onTap: () async {
                final picked = await showInventorySortSheet(
                  context,
                  current: s.sort,
                );
                if (picked != null) bloc.add(InventorySortChanged(picked));
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.swap_vert, size: 16, color: AppColors.accentText),
                  const SizedBox(width: 6),
                  Text(
                    'inventory.sortBy'.tr().toUpperCase(),
                    style: AppText.labelSm.tinted(AppColors.textSecondary),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      s.sort.labelKey.tr(),
                      overflow: TextOverflow.ellipsis,
                      style: AppText.labelMd.semiBold,
                    ),
                  ),
                  Icon(
                    Icons.expand_more,
                    size: 16,
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppColors.inset,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Row(
              children: [
                _ViewToggle(
                  icon: Icons.grid_view,
                  tooltip: 'inventory.gridView'.tr(),
                  selected: s.view == InventoryViewMode.grid,
                  onTap: () => bloc.add(
                    const InventoryViewChanged(InventoryViewMode.grid),
                  ),
                ),
                _ViewToggle(
                  icon: Icons.view_agenda_outlined,
                  tooltip: 'inventory.listView'.tr(),
                  selected: s.view == InventoryViewMode.list,
                  onTap: () => bloc.add(
                    const InventoryViewChanged(InventoryViewMode.list),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({
    required this.icon,
    required this.tooltip,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final String tooltip;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: InkWell(
      borderRadius: BorderRadius.circular(AppRadius.full),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 30,
        decoration: BoxDecoration(
          color: selected ? AppColors.card : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Icon(
          icon,
          size: 18,
          color: selected ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    ),
  );
}
