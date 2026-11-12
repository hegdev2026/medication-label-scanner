import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/common/utils/platform_style.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

/// Asks the user to confirm a delete, in the platform's own style. Resolves to
/// true when they confirm, false when they cancel or dismiss.
Future<bool> showDeleteConfirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  String? confirmLabel,
  String? cancelLabel,
  IconData icon = Icons.delete_outline_rounded,
  bool? ios,
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) => DeleteConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel ?? 'common.delete'.tr(),
        cancelLabel: cancelLabel ?? 'common.cancel'.tr(),
        icon: icon,
        ios: ios,
        onCancel: () => dialogContext.pop(false),
        onConfirm: () => dialogContext.pop(true),
      ),
    ) ??
    false;

/// The delete confirmation: an iPhone alert (a narrow centred card, Cancel and
/// Delete split by a hairline) or a Material dialog (a tonal red icon, a
/// left-aligned headline, Cancel as a text button and Delete as a red pill).
///
/// It only draws: the caller owns what Cancel and Delete do and closes it
/// (see [showDeleteConfirmDialog]).
class DeleteConfirmDialog extends StatelessWidget {
  const DeleteConfirmDialog({
    super.key,
    required this.title,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.onConfirm,
    required this.onCancel,
    this.message,
    this.icon = Icons.delete_outline_rounded,
    this.ios,
  });

  final String title;

  /// A line of supporting text under the title.
  final String? message;

  /// The icon of the Material dialog's round badge (a bin by default).
  final IconData icon;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  /// Forces a look; the platform's own when null.
  final bool? ios;

  @override
  Widget build(BuildContext context) =>
      (ios ?? isIosStyle(context)) ? _ios() : _android();

  Widget _ios() {
    final line = message;
    final hairline = AppColors.textPrimary.withValues(alpha: 0.15);
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.xl),
        child: Center(
          child: SizedBox(
            width: 270,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                      child: Column(
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: AppText.titleMd.semiBold,
                          ),
                          if (line != null && line.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              line,
                              textAlign: TextAlign.center,
                              style: AppText.bodySm.tinted(
                                AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Divider(height: 0.5, thickness: 0.5, color: hairline),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _IosAction(
                              label: cancelLabel,
                              color: AppColors.accentText,
                              bold: true,
                              onTap: onCancel,
                            ),
                          ),
                          VerticalDivider(
                            width: 0.5,
                            thickness: 0.5,
                            color: hairline,
                          ),
                          Expanded(
                            child: _IosAction(
                              label: confirmLabel,
                              color: AppColors.danger,
                              onTap: onConfirm,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _android() {
    final line = message;
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 312),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 28,
                    spreadRadius: -4,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpace.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.danger.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.danger.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Icon(icon, size: 24, color: AppColors.danger),
                    ),
                    const SizedBox(height: AppSpace.md),
                    Text(title, style: AppText.headingSm.medium),
                    if (line != null && line.isNotEmpty) ...[
                      const SizedBox(height: AppSpace.sm),
                      Text(
                        line,
                        style: AppText.bodyMd.tinted(AppColors.textSecondary),
                      ),
                    ],
                    const SizedBox(height: AppSpace.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _PillAction(
                          label: cancelLabel,
                          color: AppColors.accentText,
                          onTap: onCancel,
                        ),
                        const SizedBox(width: AppSpace.xs),
                        _PillAction(
                          label: confirmLabel,
                          color: AppColors.onAccent,
                          fill: AppColors.danger,
                          horizontal: 20,
                          onTap: onConfirm,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PillAction extends StatelessWidget {
  const _PillAction({
    required this.label,
    required this.color,
    required this.onTap,
    this.fill,
    this.horizontal = 14,
  });
  final String label;
  final Color color;
  final Color? fill;
  final double horizontal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: fill ?? AppColors.card.withValues(alpha: 0),
    shape: const StadiumBorder(),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: 10),
        child: Text(label, style: AppText.titleSm.medium.tinted(color)),
      ),
    ),
  );
}

class _IosAction extends StatelessWidget {
  const _IosAction({
    required this.label,
    required this.color,
    required this.onTap,
    this.bold = false,
  });
  final String label;
  final Color color;
  final bool bold;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Text(
          label,
          style: (bold ? AppText.titleMd.semiBold : AppText.titleMd).tinted(
            color,
          ),
        ),
      ),
    ),
  );
}
