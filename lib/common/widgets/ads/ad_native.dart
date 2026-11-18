import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:medicine_lab_reader/common/widgets/ads/ad_slot.dart';
import 'package:medicine_lab_reader/core/ads/ad_config.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';

/// A native ad in the app's own colours (Google's "small" template). Takes no
/// space until an ad has loaded, and none at all when ads are off.
class AdNative extends StatelessWidget {
  const AdNative({super.key});

  @override
  Widget build(BuildContext context) =>
      AdSlot(enabled: AdConfig.nativeOn, builder: (_) => const _NativeView());
}

class _NativeView extends StatefulWidget {
  const _NativeView();

  @override
  State<_NativeView> createState() => _NativeViewState();
}

class _NativeViewState extends State<_NativeView> {
  final _ad = ValueNotifier<NativeAd?>(null);

  @override
  void initState() {
    super.initState();
    NativeAd(
      adUnitId: AdConfig.native,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            _ad.value = ad as NativeAd;
          } else {
            ad.dispose();
          }
        },
        onAdFailedToLoad: (ad, e) {
          debugPrint('Ads: native failed: ${e.code} ${e.message}');
          ad.dispose();
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        mainBackgroundColor: AppColors.card,
        cornerRadius: AppRadius.card,
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColors.textPrimary,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColors.textSecondary,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColors.textMuted,
        ),
      ),
    ).load();
  }

  @override
  void dispose() {
    _ad.value?.dispose();
    _ad.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<NativeAd?>(
    valueListenable: _ad,
    builder: (_, ad, _) {
      if (ad == null) return const SizedBox.shrink();
      return ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 320,
          minHeight: 90,
          maxHeight: 200,
        ),
        child: AdWidget(ad: ad),
      );
    },
  );
}
