import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_skeleton.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';

/// Placeholder in the shape of a [MedicineCard] while the list loads: the
/// card's shell, a photo, the name and strength lines, and the date row.
class MedicineCardSkeleton extends StatelessWidget {
  const MedicineCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) => SkeletonCard(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Bones.block(width: 80, height: 96),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bones.pill(72, height: 18),
              const SizedBox(height: AppSpace.sm),
              Bones.line(150, height: 16),
              const SizedBox(height: 6),
              Bones.line(110, height: 11),
              const SizedBox(height: AppSpace.md),
              Row(
                children: [
                  Bones.line(70, height: 11),
                  const SizedBox(width: AppSpace.sm),
                  Bones.pill(84, height: 22),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// A few [MedicineCardSkeleton]s stacked like the list.
class MedicineListSkeleton extends StatelessWidget {
  const MedicineListSkeleton({super.key, this.count = 4});
  final int count;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (var i = 0; i < count; i++)
        const Padding(
          padding: EdgeInsets.only(bottom: AppSpace.sm),
          child: MedicineCardSkeleton(),
        ),
    ],
  );
}
