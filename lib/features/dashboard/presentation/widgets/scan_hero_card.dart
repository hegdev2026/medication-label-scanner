import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_button.dart';
import 'package:medicine_lab_reader/common/widgets/scan_reticle.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

/// Deep-green hero with a reticle preview and the main "Start scanning" CTA.
class ScanHeroCard extends StatelessWidget {
  const ScanHeroCard({super.key, required this.onScan});
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(28),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.hero,
        boxShadow: [
          BoxShadow(
            color: AppColors.hero.withValues(alpha: 0.28),
            blurRadius: 36,
            spreadRadius: -6,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(right: -64, top: -64, child: _Glow(size: 224)),
          const Positioned(left: -40, bottom: -40, child: _Glow(size: 176)),
          Padding(
            padding: const EdgeInsets.all(AppSpace.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _StatusChip(),
                const SizedBox(height: AppSpace.lg),
                Text(
                  'dashboard.heroTitle'.tr(),
                  style: AppText.headingMd.tinted(AppColors.onAccent),
                ),
                const SizedBox(height: AppSpace.xs),
                Text(
                  'dashboard.heroSub'.tr(),
                  style: AppText.bodyMd.tinted(AppColors.heroMuted),
                ),
                const SizedBox(height: AppSpace.lg),
                const _ReticlePreview(),
                const SizedBox(height: AppSpace.lg),
                AppButton(
                  kind: AppButtonKind.accent,
                  label: 'dashboard.startScanning'.tr(),
                  icon: Icons.photo_camera,
                  onPressed: onScan,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.accent.withValues(alpha: 0.22),
            AppColors.accent.withValues(alpha: 0),
          ],
        ),
      ),
    ),
  );
}

class _StatusChip extends StatelessWidget {
  const _StatusChip();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.onAccent.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(AppRadius.full),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            'dashboard.heroChip'.tr().toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.labelSm.tinted(AppColors.accent),
          ),
        ),
      ],
    ),
  );
}

/// Decorative viewfinder: reticle corners and a sweeping laser line only. It
/// shows no sample medicine or readings, so nothing here can be mistaken for
/// real data.
class _ReticlePreview extends StatelessWidget {
  const _ReticlePreview();

  @override
  Widget build(BuildContext context) => Container(
    // Fill the card: the column is start-aligned, so without an explicit width
    // the box shrinks to its (empty) content.
    width: double.infinity,
    height: 176,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppRadius.xl + AppRadius.sm),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.scanSurface, AppColors.hero],
      ),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.medication_outlined,
          size: 56,
          color: AppColors.accent.withValues(alpha: 0.35),
        ),
        const Positioned.fill(
          child: ScanReticle(armLength: 20, stroke: 2, inset: 12, radius: 4),
        ),
        const Positioned.fill(child: ScanLine()),
      ],
    ),
  );
}
