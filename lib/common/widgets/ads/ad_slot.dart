import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/core/ads/ads_cubit.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

/// Gate for an ad: nothing at all while ads are off (not ready, unsupported
/// platform or the SDK has not started). The ad view itself shows [AdFrame]
/// only once an ad has really loaded, so there is never an empty
/// "Advertisement" label.
class AdSlot extends StatelessWidget {
  const AdSlot({super.key, required this.enabled, required this.builder});

  /// False when this ad format has no unit in this build.
  final bool enabled;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return const SizedBox.shrink();
    return BlocBuilder<AdsCubit, AdsState>(
      buildWhen: (a, b) => a.showAds != b.showAds,
      builder: (context, s) =>
          s.showAds ? builder(context) : const SizedBox.shrink(),
    );
  }
}

/// A small "Advertisement" label above a loaded ad, so an ad is never mistaken
/// for medicine information.
class AdFrame extends StatelessWidget {
  const AdFrame({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'ads.label'.tr(),
          style: AppText.labelSm.regular.tinted(AppColors.textMuted),
        ),
        const SizedBox(height: AppSpace.xs),
        child,
      ],
    ),
  );
}
