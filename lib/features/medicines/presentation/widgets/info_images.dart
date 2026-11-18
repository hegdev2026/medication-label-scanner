import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

/// Package or label pictures from the FDA label, as a scrolling strip. Tap one
/// to see it larger. A picture that fails to load is simply left out.
class InfoImages extends StatelessWidget {
  const InfoImages({super.key, required this.urls});
  final List<String> urls;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 150,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: urls.length,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpace.sm),
          itemBuilder: (context, i) =>
              _Thumb(url: urls[i], onTap: () => _open(context, urls[i])),
        ),
      ),
      const SizedBox(height: 6),
      Text(
        'info.imagesNote'.tr(),
        style: AppText.labelSm.regular.tinted(AppColors.textMuted),
      ),
    ],
  );

  void _open(BuildContext context, String url) => showDialog<void>(
    context: context,
    builder: (dialogContext) => Dialog(
      backgroundColor: AppColors.card,
      insetPadding: const EdgeInsets.all(AppSpace.md),
      child: Stack(
        children: [
          InteractiveViewer(
            maxScale: 5,
            child: Image.network(url, fit: BoxFit.contain),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              tooltip: 'common.cancel'.tr(),
              icon: const Icon(Icons.close),
              onPressed: () => dialogContext.pop(),
            ),
          ),
        ],
      ),
    ),
  );
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.url, required this.onTap});
  final String url;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(AppRadius.xl),
    child: Material(
      color: AppColors.inset,
      child: InkWell(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            url,
            fit: BoxFit.cover,
            cacheWidth: 400,
            loadingBuilder: (_, child, progress) => progress == null
                ? child
                : Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
            errorBuilder: (_, _, _) => Icon(
              Icons.image_not_supported_outlined,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ),
    ),
  );
}
