import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/bloc/inventory/inventory_bloc.dart';

/// Bottom sheet listing the sort options; returns the one the user picked.
Future<InventorySort?> showInventorySortSheet(
  BuildContext context, {
  required InventorySort current,
}) => showModalBottomSheet<InventorySort>(
  context: context,
  showDragHandle: true,
  backgroundColor: AppColors.card,
  builder: (sheetContext) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.lg,
        0,
        AppSpace.lg,
        AppSpace.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('inventory.sortBy'.tr(), style: AppText.titleMd),
          const SizedBox(height: AppSpace.sm),
          for (final o in InventorySort.values)
            _SortOption(
              label: o.labelKey.tr(),
              selected: o == current,
              onTap: () => sheetContext.pop(o),
            ),
        ],
      ),
    ),
  ),
);

class _SortOption extends StatelessWidget {
  const _SortOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpace.sm),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
    selected: selected,
    selectedTileColor: AppColors.primaryContainer,
    title: Text(label, style: selected ? AppText.titleSm : AppText.bodyMd),
    trailing: selected
        ? Icon(Icons.check_circle, color: AppColors.primary)
        : null,
  );
}
