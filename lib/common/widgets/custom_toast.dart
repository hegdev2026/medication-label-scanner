import 'dart:async';

import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

enum ToastType { success, error, warning, info }

/// Status messages. Use instead of ScaffoldMessenger / SnackBar.
class CustomToast {
  CustomToast._();
  static OverlayEntry? _entry;
  static Timer? _timer;

  static void show(BuildContext context, String message, ToastType type) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;
    _remove();
    final color = switch (type) {
      ToastType.success => AppColors.success,
      ToastType.error => AppColors.danger,
      ToastType.warning => AppColors.warning,
      ToastType.info => AppColors.primary,
    };
    _entry = OverlayEntry(
      builder: (_) => Positioned(
        left: AppSpace.lg,
        right: AppSpace.lg,
        bottom: AppSpace.xl + MediaQuery.paddingOf(context).bottom,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Material(
              color: AppColors.card,
              elevation: 4,
              shadowColor: AppColors.shadow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                side: BorderSide(color: color),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpace.md),
                child: Row(
                  children: [
                    Icon(_icon(type), color: color),
                    const SizedBox(width: AppSpace.sm),
                    Expanded(child: Text(message, style: AppText.bodyMd)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final entry = _entry;
    if (entry == null) return;
    overlay.insert(entry);
    _timer = Timer(const Duration(seconds: 3), _remove);
  }

  static IconData _icon(ToastType t) => switch (t) {
    ToastType.success => Icons.check_circle_outline,
    ToastType.error => Icons.error_outline,
    ToastType.warning => Icons.warning_amber_outlined,
    ToastType.info => Icons.info_outline,
  };

  static void _remove() {
    _timer?.cancel();
    _timer = null;
    _entry?.remove();
    _entry = null;
  }
}
