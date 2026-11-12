import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/constants/app_assets.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

/// Top bar of the root tab screens: lens mark, app name and page title.
class BrandAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BrandAppBar({super.key, required this.title});
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) => AppBar(
    toolbarHeight: 64,
    automaticallyImplyLeading: false,
    titleSpacing: AppSpace.margin,
    title: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Image.asset(
            AppAssets.logoMark,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            semanticLabel: 'app.title'.tr(),
          ),
        ),
        const SizedBox(width: AppSpace.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'app.title'.tr().toUpperCase(),
              style: AppText.labelSm
                  .tinted(AppColors.accentText)
                  .copyWith(letterSpacing: 1.2),
            ),
            Text(title, style: AppText.titleMd.copyWith(height: 1.1)),
          ],
        ),
      ],
    ),
  );
}
