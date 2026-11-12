import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

/// Soft filled text field (no outline until focused) that can show a
/// "needs review" state.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.needsReview = false,
    this.hint,
    this.suffix,
    this.validator,
    this.maxLines = 1,
    this.keyboardType,
    this.icon,
  });
  final TextEditingController controller;
  final String label;
  final bool needsReview;
  final String? hint;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputType? keyboardType;
  final IconData? icon;

  OutlineInputBorder _border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        borderSide: color == Colors.transparent
            ? BorderSide.none
            : BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    final flagColor = AppColors.warning;
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      // Keeps the focused field well clear of the keyboard when it scrolls
      // into view.
      scrollPadding: const EdgeInsets.only(bottom: 120),
      style: AppText.bodyMd,
      cursorColor: AppColors.accentText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppText.bodyMd.tinted(AppColors.textSecondary),
        floatingLabelStyle: AppText.labelMd.tinted(
          needsReview ? flagColor : AppColors.accentText,
        ),
        hintText: hint,
        hintStyle: AppText.bodyMd.tinted(AppColors.textMuted),
        filled: true,
        fillColor: needsReview
            ? AppColors.warningBg.withValues(alpha: 0.6)
            : AppColors.inset,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpace.lg,
          vertical: AppSpace.md,
        ),
        prefixIcon: icon == null
            ? null
            : Icon(icon, size: 20, color: AppColors.textSecondary),
        suffixIcon:
            suffix ??
            (needsReview
                ? Icon(Icons.error_outline, size: 20, color: flagColor)
                : null),
        helperText: needsReview ? 'form.checkValue'.tr() : null,
        helperStyle: AppText.bodySm.tinted(flagColor),
        border: _border(Colors.transparent),
        enabledBorder: needsReview
            ? _border(flagColor.withValues(alpha: 0.6), 1.5)
            : _border(Colors.transparent),
        focusedBorder: _border(
          needsReview ? flagColor : AppColors.accentText,
          2,
        ),
        errorBorder: _border(AppColors.danger, 1.5),
        focusedErrorBorder: _border(AppColors.danger, 2),
      ),
    );
  }
}
