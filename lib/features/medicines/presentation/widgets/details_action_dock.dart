import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_button.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';

/// Bottom dock: scan another (primary), edit and delete.
class DetailsActionDock extends StatelessWidget {
  const DetailsActionDock({
    super.key,
    required this.onScanAnother,
    required this.onEdit,
    required this.onDelete,
  });
  final VoidCallback onScanAnother, onEdit, onDelete;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: AppColors.background.withValues(alpha: 0.92),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 24,
          offset: const Offset(0, -8),
        ),
      ],
    ),
    child: SafeArea(
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(AppSpace.margin),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(
                  label: 'details.scanAnother'.tr(),
                  icon: Icons.document_scanner_outlined,
                  onPressed: onScanAnother,
                ),
                const SizedBox(height: AppSpace.sm),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        kind: AppButtonKind.tonal,
                        label: 'common.edit'.tr(),
                        icon: Icons.edit_outlined,
                        onPressed: onEdit,
                      ),
                    ),
                    const SizedBox(width: AppSpace.sm),
                    Expanded(
                      child: AppButton(
                        kind: AppButtonKind.outlined,
                        label: 'common.delete'.tr(),
                        icon: Icons.delete_outline,
                        onPressed: onDelete,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
