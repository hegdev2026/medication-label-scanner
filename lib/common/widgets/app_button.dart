import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

/// All kinds share one flat 48px pill (no shadow).
/// * [filled]   – forest-green primary action.
/// * [accent]   – bright mint pill, for use on dark/green surfaces.
/// * [tonal]    – light-mint secondary pill.
/// * [outlined] – ghost pill with a hairline border.
/// * [text]     – borderless.
enum AppButtonKind { filled, accent, tonal, outlined, text }

/// The one button of the app. Extend this rather than using raw Material buttons.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.kind = AppButtonKind.filled,
    this.loading = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonKind kind;
  final bool loading;
  final bool expand;

  /// One height for every kind, matching the compact inventory button.
  static const double _height = 48;

  @override
  Widget build(BuildContext context) {
    const shape = StadiumBorder();
    const padding = EdgeInsets.symmetric(horizontal: AppSpace.lg);
    final size = Size(expand ? double.infinity : 48, _height);
    final enabled = onPressed != null && !loading;
    final fg = _fg(enabled);
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: fg),
          )
        else if (icon != null)
          Icon(icon, size: 20, color: fg),
        if (loading || icon != null) const SizedBox(width: AppSpace.sm),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: AppText.titleSm.tinted(fg),
          ),
        ),
      ],
    );
    final handler = enabled ? onPressed : null;
    return switch (kind) {
      AppButtonKind.filled || AppButtonKind.accent => FilledButton(
        onPressed: handler,
        style: FilledButton.styleFrom(
          minimumSize: size,
          shape: shape,
          elevation: 0,
          padding: padding,
          backgroundColor: kind == AppButtonKind.accent
              ? AppColors.accent
              : AppColors.primary,
          disabledBackgroundColor: AppColors.inset,
        ),
        child: child,
      ),
      AppButtonKind.tonal => FilledButton(
        onPressed: handler,
        style: FilledButton.styleFrom(
          minimumSize: size,
          shape: shape,
          elevation: 0,
          padding: padding,
          backgroundColor: AppColors.primaryContainer,
          disabledBackgroundColor: AppColors.inset,
        ),
        child: child,
      ),
      AppButtonKind.outlined => OutlinedButton(
        onPressed: handler,
        style: OutlinedButton.styleFrom(
          minimumSize: size,
          shape: shape,
          padding: padding,
          backgroundColor: AppColors.card,
          side: BorderSide(color: AppColors.border),
        ),
        child: child,
      ),
      AppButtonKind.text => TextButton(
        onPressed: handler,
        style: TextButton.styleFrom(
          minimumSize: size,
          shape: shape,
          padding: padding,
        ),
        child: child,
      ),
    };
  }

  Color _fg(bool enabled) {
    if (!enabled) return AppColors.textMuted;
    return switch (kind) {
      AppButtonKind.filled =>
        AppColors.isDark ? AppColors.onAccentFill : AppColors.onAccent,
      AppButtonKind.accent => AppColors.onAccentFill,
      AppButtonKind.tonal => AppColors.onPrimaryContainer,
      AppButtonKind.outlined => AppColors.textPrimary,
      AppButtonKind.text => AppColors.primary,
    };
  }
}
