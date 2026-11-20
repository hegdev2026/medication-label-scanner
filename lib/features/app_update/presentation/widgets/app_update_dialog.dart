import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/common/widgets/app_button.dart';

enum AppUpdatePrompt { available, ready }

/// The update question. A [mandatory] one has no Later, cannot be dismissed by
/// tapping outside, and Back does nothing. True means "yes, update".
Future<bool> showAppUpdateDialog(
  BuildContext context, {
  required AppUpdatePrompt prompt,
  required bool mandatory,
}) async =>
    await showDialog<bool>(
      context: context,
      barrierDismissible: !mandatory,
      builder: (dialogContext) => PopScope(
        canPop: !mandatory,
        child: AlertDialog(
          title: Text(
            (prompt == AppUpdatePrompt.available
                    ? 'update.title'
                    : 'update.readyTitle')
                .tr(),
          ),
          content: Text(
            (prompt == AppUpdatePrompt.available
                    ? 'update.message'
                    : 'update.readyMessage')
                .tr(),
          ),
          actions: [
            if (!mandatory)
              AppButton(
                label: 'update.later'.tr(),
                kind: AppButtonKind.text,
                expand: false,
                onPressed: () => dialogContext.pop(false),
              ),
            AppButton(
              label:
                  (prompt == AppUpdatePrompt.available
                          ? 'update.now'
                          : 'update.restart')
                      .tr(),
              expand: false,
              onPressed: () => dialogContext.pop(true),
            ),
          ],
        ),
      ),
    ) ??
    false;
