import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/bloc/inventory/inventory_bloc.dart';

class InventorySearchBar extends StatelessWidget {
  const InventorySearchBar({super.key, required this.onAddScan});

  /// Shown as a compact add button beside the field, saving a whole row.
  final VoidCallback onAddScan;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.xl);
    final field = TextField(
      onChanged: (v) =>
          context.read<InventoryBloc>().add(InventorySearchChanged(v)),
      style: AppText.bodyMd,
      decoration: InputDecoration(
        hintText: 'inventory.searchHint'.tr(),
        hintStyle: AppText.bodyMd.tinted(AppColors.textMuted),
        prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(
            color: AppColors.accentText.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
      ),
    );
    return Row(
      children: [
        Expanded(child: field),
        const SizedBox(width: AppSpace.sm),
        Tooltip(
          message: 'inventory.addScan'.tr(),
          child: Material(
            color: AppColors.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onAddScan,
              child: SizedBox(
                width: 48,
                height: 48,
                child: Icon(
                  Icons.add_a_photo_outlined,
                  color: AppColors.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
