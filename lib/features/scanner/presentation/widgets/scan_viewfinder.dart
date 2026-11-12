import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/scan_reticle.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

/// The framed OCR zone: grid, reticle corners, sweeping laser and a hint pill.
/// It is guidance only; no sample or detected text is drawn.
class ScanViewfinder extends StatelessWidget {
  const ScanViewfinder({super.key});

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 310),
    child: AspectRatio(
      aspectRatio: 4 / 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.sheet),
          border: Border.all(color: AppColors.accent.withValues(alpha: 0.35)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.scanControl, AppColors.scanSurface],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sheet),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _GridPainter(
                    AppColors.accent.withValues(alpha: 0.07),
                  ),
                ),
              ),
              Icon(
                Icons.document_scanner_outlined,
                size: 72,
                color: AppColors.accent.withValues(alpha: 0.25),
              ),
              const Positioned.fill(child: ScanReticle()),
              const Positioned.fill(child: ScanLine()),
              Positioned(
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpace.md,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.scanSurface.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(
                      color: AppColors.onAccent.withValues(alpha: 0.2),
                    ),
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
                      Text(
                        'scan.frameHint'.tr(),
                        style: AppText.labelMd.tinted(AppColors.onAccent),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _GridPainter extends CustomPainter {
  const _GridPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (var y = 0.0; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.color != color;
}
