import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';

enum AppSurfaceKind { card, inset, tinted }

/// Themed container. Use instead of a hand-rolled decorated Container.
///
/// [AppSurfaceKind.card] is the resting data card: white, hairline border and
/// the soft two-layer ambient shadow from the design spec.
class AppSurface extends StatelessWidget {
  const AppSurface({
    super.key,
    required this.child,
    this.kind = AppSurfaceKind.card,
    this.fill,
    this.padding = const EdgeInsets.all(AppSpace.lg),
    this.radius = AppRadius.card,
    this.onTap,
  });

  final Widget child;
  final AppSurfaceKind kind;

  /// Fill for [AppSurfaceKind.tinted].
  final Color? fill;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = switch (kind) {
      AppSurfaceKind.card => AppColors.card,
      AppSurfaceKind.inset => AppColors.inset,
      AppSurfaceKind.tinted => fill ?? AppColors.inset,
    };
    final shape = BorderRadius.circular(radius);
    final isCard = kind == AppSurfaceKind.card;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        boxShadow: isCard
            ? [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 20,
                  spreadRadius: -2,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: shape,
          side: isCard ? BorderSide(color: AppColors.border) : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
