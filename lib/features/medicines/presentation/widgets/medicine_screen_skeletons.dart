import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_skeleton.dart';
import 'package:medicine_lab_reader/common/widgets/content_wrapper.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';

/// Placeholder for the medicine details screen: the photo and a few cards.
class MedicineDetailsSkeleton extends StatelessWidget {
  const MedicineDetailsSkeleton({super.key});

  Widget _row() => Padding(
    padding: const EdgeInsets.only(bottom: AppSpace.md),
    child: Row(
      children: [
        Bones.line(90, height: 11),
        const Spacer(),
        Bones.line(120, height: 13),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => ContentWrapper(
    scrollable: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSkeleton(child: Bones.block(height: 220, radius: AppRadius.xl)),
        const SizedBox(height: AppSpace.md),
        SkeletonCard(
          padding: const EdgeInsets.all(AppSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bones.line(180, height: 20),
              const SizedBox(height: AppSpace.sm),
              Bones.line(120, height: 12),
              const SizedBox(height: AppSpace.lg),
              Bones.pill(96, height: 24),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.md),
        SkeletonCard(
          padding: const EdgeInsets.all(AppSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bones.line(110, height: 14),
              const SizedBox(height: AppSpace.md),
              _row(),
              _row(),
              _row(),
            ],
          ),
        ),
      ],
    ),
  );
}

/// Placeholder for the add / edit / review form.
class MedicineFormSkeleton extends StatelessWidget {
  const MedicineFormSkeleton({super.key});

  Widget _field() => Padding(
    padding: const EdgeInsets.only(bottom: AppSpace.md),
    child: Bones.block(height: 56, radius: AppRadius.xl),
  );

  @override
  Widget build(BuildContext context) => ContentWrapper(
    scrollable: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSkeleton(child: Bones.block(height: 240, radius: AppRadius.xl)),
        const SizedBox(height: AppSpace.lg),
        SkeletonCard(
          padding: const EdgeInsets.all(AppSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bones.line(120, height: 14),
              const SizedBox(height: AppSpace.md),
              _field(),
              _field(),
              _field(),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.md),
        SkeletonCard(
          padding: const EdgeInsets.all(AppSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bones.line(100, height: 14),
              const SizedBox(height: AppSpace.md),
              _field(),
              _field(),
            ],
          ),
        ),
      ],
    ),
  );
}
