import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:medicine_lab_reader/common/widgets/ads/ad_slot.dart';
import 'package:medicine_lab_reader/core/ads/ad_config.dart';

/// An adaptive banner sized to the screen width. Takes no space until an ad
/// has loaded, and none at all when ads are off.
class AdBanner extends StatelessWidget {
  const AdBanner({super.key});

  @override
  Widget build(BuildContext context) =>
      AdSlot(enabled: AdConfig.bannerOn, builder: (_) => const _BannerView());
}

class _BannerView extends StatefulWidget {
  const _BannerView();

  @override
  State<_BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<_BannerView> {
  final _ad = ValueNotifier<BannerAd?>(null);
  bool _requested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_requested) return;
    _requested = true;
    _load(MediaQuery.sizeOf(context).width.truncate());
  }

  Future<void> _load(int width) async {
    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);
    if (size == null || !mounted) return;
    BannerAd(
      adUnitId: AdConfig.banner,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            _ad.value = ad as BannerAd;
          } else {
            ad.dispose();
          }
        },
        onAdFailedToLoad: (ad, e) {
          debugPrint('Ads: banner failed: ${e.code} ${e.message}');
          ad.dispose();
        },
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
  Widget build(BuildContext context) => ValueListenableBuilder<BannerAd?>(
    valueListenable: _ad,
    builder: (_, ad, _) {
      if (ad == null) return const SizedBox.shrink();
      return SizedBox(
        width: ad.size.width.toDouble(),
        height: ad.size.height.toDouble(),
        child: AdWidget(ad: ad),
      );
    },
  );
}
