import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/common/widgets/app_button.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmLabel,
  String? cancelLabel,
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          AppButton(
            label: cancelLabel ?? 'common.cancel'.tr(),
            kind: AppButtonKind.text,
            expand: false,
            onPressed: () => dialogContext.pop(false),
          ),
          AppButton(
            label: confirmLabel ?? 'common.confirm'.tr(),
            expand: false,
            onPressed: () => dialogContext.pop(true),
          ),
        ],
      ),
    ) ??
    false;
