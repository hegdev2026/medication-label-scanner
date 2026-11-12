import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:medicine_lab_reader/common/widgets/app_skeleton.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';

/// Placeholder for a row of three [SummaryTile]s.
class SummaryRowSkeleton extends StatelessWidget {
  const SummaryRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (var i = 0; i < 3; i++) ...[
        if (i > 0) const SizedBox(width: AppSpace.sm),
        Expanded(
          child: SkeletonCard(
            radius: AppRadius.lg,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpace.sm + 2,
              vertical: AppSpace.sm,
            ),
            child: Row(
              children: [
                const Bone.circle(size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Bones.line(22, height: 14),
                      const SizedBox(height: 4),
                      Bones.line(48, height: 9),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ],
  );
}

/// Placeholder for a scrolling row of [FilterPill]s.
class ChipRowSkeleton extends StatelessWidget {
  const ChipRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 40,
    child: AppSkeleton(
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (final w in const [64.0, 88.0, 96.0, 84.0, 90.0])
            Padding(
              padding: const EdgeInsets.only(right: AppSpace.sm),
              child: Bones.pill(w, height: 40),
            ),
        ],
      ),
    ),
  );
}
