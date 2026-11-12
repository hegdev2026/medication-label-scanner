import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/expiry_pill.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_menu_button.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_thumb.dart';

/// Library card (grid view): stacked and compact.
class MedicineGridCard extends StatelessWidget {
  const MedicineGridCard({
    super.key,
    required this.medicine,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });
  final Medicine medicine;
  final VoidCallback onTap, onEdit, onDelete;

  @override
  Widget build(BuildContext context) {
    final m = medicine;
    final strength = m.strength;
    return AppSurface(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              LayoutBuilder(
                builder: (_, c) =>
                    MedicineThumb(medicine: m, width: c.maxWidth, height: 104),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: MedicineMenuButton(onEdit: onEdit, onDelete: onDelete),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.sm),
          Text(
            m.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.titleMd,
          ),
          Text(
            strength ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.bodySm,
          ),
          const SizedBox(height: AppSpace.sm),
          ExpiryPill(medicine: m),
        ],
      ),
    );
  }
}
