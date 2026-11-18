import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:medicine_lab_reader/common/widgets/app_button.dart';
import 'package:medicine_lab_reader/common/widgets/app_pill.dart';
import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/core/constants/app_api.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_info.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/details_card_header.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/info_images.dart';

/// Brief general reference: uses, how it works, how to use, side effects and
/// safety advice. Shown only for a confident name match.
class MedicineInfoCard extends StatelessWidget {
  const MedicineInfoCard({super.key, required this.info});
  final MedicineInfo info;

  @override
  Widget build(BuildContext context) => AppSurface(
    padding: const EdgeInsets.all(AppSpace.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailsCardHeader(
          icon: Icons.menu_book_outlined,
          title: 'info.title'.tr(),
          subtitle: info.title,
          trailing: AppPill(
            label: 'info.badge'.tr(),
            tone: AppPillTone.neutral,
            compact: true,
          ),
        ),
        if (info.summary.isNotEmpty) ...[
          const SizedBox(height: AppSpace.md),
          Text(info.summary, style: AppText.bodyMd),
        ],
        if (info.images.isNotEmpty) ...[
          const SizedBox(height: AppSpace.md),
          InfoImages(urls: info.images),
        ],
        _Bullets(
          icon: Icons.check_circle_outline,
          title: 'info.uses'.tr(),
          items: info.uses,
          color: AppColors.success,
        ),
        _Bullets(
          icon: Icons.error_outline,
          title: 'info.sideEffects'.tr(),
          items: info.sideEffects,
          color: AppColors.warning,
        ),
        _Bullets(
          icon: Icons.shield_outlined,
          title: 'info.safety'.tr(),
          items: info.safety,
          color: AppColors.primary,
        ),
        const SizedBox(height: AppSpace.md),
        Text(
          'info.source'.tr(args: [info.sourceLabel ?? AppApi.sourceNames]),
          style: AppText.labelSm.regular.tinted(AppColors.textMuted),
        ),
        if (info.moreInfoUrl case final url?) ...[
          const SizedBox(height: AppSpace.sm),
          AppButton(
            label: 'info.readMore'.tr(),
            icon: Icons.open_in_new,
            kind: AppButtonKind.tonal,
            expand: true,
            onPressed: () =>
                launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
          ),
        ],
      ],
    ),
  );
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpace.md, bottom: 6),
    child: Text(text, style: AppText.labelMd.bold),
  );
}

class _Bullets extends StatelessWidget {
  const _Bullets({
    required this.icon,
    required this.title,
    required this.items,
    required this.color,
  });
  final IconData icon;
  final String title;
  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Heading(title),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 10),
                Expanded(child: Text(item, style: AppText.bodyMd)),
              ],
            ),
          ),
      ],
    );
  }
}
