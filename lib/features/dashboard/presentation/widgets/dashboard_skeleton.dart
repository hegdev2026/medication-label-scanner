import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:medicine_lab_reader/common/widgets/app_skeleton.dart';
import 'package:medicine_lab_reader/common/widgets/content_wrapper.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';

/// The Home screen's placeholder while it loads: the same cards as the real
/// page, with grey bones and a sweeping light, so nothing jumps when the data
/// arrives.
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  Widget _quickAction() => Expanded(
    child: SkeletonCard(
      radius: AppRadius.xl + AppRadius.sm,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.sm,
        vertical: AppSpace.md,
      ),
      child: Column(
        children: [
          const Bone.circle(size: 48),
          const SizedBox(height: AppSpace.sm),
          Bones.line(52, height: 12),
          const SizedBox(height: 4),
          Bones.line(40, height: 9),
        ],
      ),
    ),
  );

  Widget _recentCard() => SizedBox(
    width: 220,
    child: SkeletonCard(
      padding: const EdgeInsets.all(AppSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Bones.block(width: 56, height: 64),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bones.line(100, height: 14),
                    const SizedBox(height: 6),
                    Bones.line(70, height: 10),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          Bones.line(120, height: 10),
          const SizedBox(height: AppSpace.sm),
          Bones.pill(96, height: 22),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => ContentWrapper(
    scrollable: true,
    maxWidth: 720,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Greeting.
        AppSkeleton(
          child: Row(
            children: [
              Bones.block(width: 44, height: 44, radius: AppRadius.xl),
              const SizedBox(width: AppSpace.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Bones.line(120, height: 16),
                  const SizedBox(height: 6),
                  Bones.line(190, height: 11),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.lg),
        // Scan hero card.
        SkeletonCard(
          radius: AppRadius.sheet + 4,
          padding: const EdgeInsets.all(AppSpace.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bones.pill(190, height: 24),
              const SizedBox(height: AppSpace.lg),
              Bones.line(200, height: 22),
              const SizedBox(height: AppSpace.sm),
              Bones.line(double.infinity, height: 12),
              const SizedBox(height: 6),
              Bones.line(160, height: 12),
              const SizedBox(height: AppSpace.lg),
              Bones.block(height: 150, radius: AppRadius.xl + AppRadius.sm),
              const SizedBox(height: AppSpace.lg),
              Bones.pill(double.infinity, height: 48),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.xl),
        // Quick actions.
        AppSkeleton(child: Bones.line(96, height: 11)),
        const SizedBox(height: AppSpace.sm),
        Row(
          children: [
            _quickAction(),
            const SizedBox(width: AppSpace.md),
            _quickAction(),
            const SizedBox(width: AppSpace.md),
            _quickAction(),
          ],
        ),
        const SizedBox(height: AppSpace.xl),
        // Recently scanned.
        AppSkeleton(
          child: Row(
            children: [
              Bones.line(130, height: 16),
              const Spacer(),
              Bones.line(52, height: 12),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.sm),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            clipBehavior: Clip.none,
            children: [
              _recentCard(),
              const SizedBox(width: AppSpace.md),
              _recentCard(),
            ],
          ),
        ),
      ],
    ),
  );
}
