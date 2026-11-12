import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';

/// The app's loading placeholder: the real screen's own shells with grey bones
/// where text, numbers and pictures go, and a light band sweeping over the
/// bones. Use [AppSkeleton] for bones laid out by hand, or
/// [AppSkeletonizer] where real widgets with sample data turn into their own
/// skeleton while [enabled].
///
/// People who ask for less motion get still bones, without the sweep.
class AppSkeletonizer extends StatelessWidget {
  const AppSkeletonizer({
    super.key,
    required this.enabled,
    required this.child,
    this.ignoreContainers = false,
  });

  final bool enabled;
  final Widget child;

  /// True drops the containers' own paint, cards and panels included, so a
  /// card shell must sit outside the skeleton; false turns them into bones.
  final bool ignoreContainers;

  @override
  Widget build(BuildContext context) {
    final still = MediaQuery.disableAnimationsOf(context);
    return Skeletonizer(
      enabled: enabled,
      ignoreContainers: ignoreContainers,
      effect: still
          ? SolidColorEffect(color: AppColors.shimmerBase)
          : ShimmerEffect(
              baseColor: AppColors.shimmerBase,
              highlightColor: AppColors.shimmerHighlight,
              duration: const Duration(milliseconds: 1400),
            ),
      child: child,
    );
  }
}

/// A skeleton that is always on, for bones ([Bone]) laid out by hand. Keep a
/// card's shell OUTSIDE it and only the bones inside: a container inside a
/// skeleton loses its own paint (see [SkeletonCard]).
class AppSkeleton extends StatelessWidget {
  const AppSkeleton({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      AppSkeletonizer(enabled: true, ignoreContainers: true, child: child);
}

/// A card's real shell with [child] bones inside it.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpace.md),
    this.radius = AppRadius.card,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) => AppSurface(
    padding: padding,
    radius: radius,
    child: AppSkeleton(child: child),
  );
}

/// Bone shortcuts so layouts stay short.
abstract final class Bones {
  /// A grey rounded bar, one line of text.
  static Widget line(double width, {double height = 12}) => Bone(
    width: width,
    height: height,
    borderRadius: BorderRadius.circular(AppRadius.sm),
  );

  /// A rounded block (picture, chart, control).
  static Widget block({
    double? width,
    required double height,
    double radius = AppRadius.lg,
  }) => Bone(
    width: width,
    height: height,
    borderRadius: BorderRadius.circular(radius),
  );

  /// A pill (chip, tag).
  static Widget pill(double width, {double height = 22}) =>
      block(width: width, height: height, radius: AppRadius.full);
}
