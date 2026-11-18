import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/core/ads/ads_cubit.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

/// Frames an ad: nothing at all while ads are off (not ready, unsupported
/// platform or the SDK has not started), otherwise a small "Advertisement" label
/// above [child] so an ad is never mistaken for medicine information.
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
      builder: (context, s) {
        if (!s.showAds) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'ads.label'.tr(),
                style: AppText.labelSm.regular.tinted(AppColors.textMuted),
              ),
              const SizedBox(height: AppSpace.xs),
              builder(context),
            ],
          ),
        );
      },
    );
  }
}
