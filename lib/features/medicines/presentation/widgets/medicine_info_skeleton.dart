import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_skeleton.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';

/// Placeholder shown while general medicine information is being fetched.
class MedicineInfoSkeleton extends StatelessWidget {
  const MedicineInfoSkeleton({super.key});

  @override
  Widget build(BuildContext context) => SkeletonCard(
    padding: const EdgeInsets.all(AppSpace.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Bones.line(140, height: 16),
        const SizedBox(height: AppSpace.md),
        Bones.line(double.infinity),
        const SizedBox(height: 8),
        Bones.line(double.infinity),
        const SizedBox(height: 8),
        Bones.line(180),
      ],
    ),
  );
}
