import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/image_source_service.dart';
import 'package:medicine_lab_reader/features/scanner/presentation/bloc/scan_bloc.dart';

/// Import (left), shutter (centre), manual entry (right).
class ScanControls extends StatelessWidget {
  const ScanControls({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ScanBloc>();
    final camera = bloc.cameraSupported;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _SideControl(
          icon: Icons.photo_library_outlined,
          label: 'scan.import'.tr(),
          onTap: () => bloc.add(const ScanRequested(ImageOrigin.gallery)),
        ),
        _Shutter(
          label: (camera ? 'scan.takePhoto' : 'scan.selectFile').tr(),
          onTap: () => bloc.add(
            ScanRequested(camera ? ImageOrigin.camera : ImageOrigin.gallery),
          ),
        ),
        _SideControl(
          icon: Icons.keyboard_outlined,
          label: 'scan.manualShort'.tr(),
          onTap: () => context.push(AppRoutes.medicineNew),
        ),
      ],
    );
  }
}

class _SideControl extends StatelessWidget {
  const _SideControl({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 72,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.scanControl,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(
                color: AppColors.onAccent.withValues(alpha: 0.15),
              ),
            ),
            child: Icon(icon, color: AppColors.heroMuted),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.labelMd.regular.tinted(AppColors.heroMuted),
          ),
        ],
      ),
    ),
  );
}

class _Shutter extends StatelessWidget {
  const _Shutter({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 78,
        height: 78,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accent.withValues(alpha: 0.7),
              AppColors.accentText,
              AppColors.hero,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentText.withValues(alpha: 0.45),
              blurRadius: 28,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.scanSurface,
            border: Border.all(
              color: AppColors.onAccent.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          child: Center(
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.9),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Icon(
                Icons.document_scanner_outlined,
                size: 20,
                color: AppColors.onAccentFill,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
