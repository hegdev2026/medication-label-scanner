import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/common/widgets/app_button.dart';
import 'package:medicine_lab_reader/common/widgets/custom_toast.dart';
import 'package:medicine_lab_reader/common/widgets/section_card.dart';
import 'package:medicine_lab_reader/core/ads/ad_config.dart';
import 'package:medicine_lab_reader/core/ads/ads_cubit.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

/// Settings: hide ads for a day by watching one video, and (where the law
/// requires it) change ad privacy choices. Hidden when this build has no ads.
class AdsCard extends StatelessWidget {
  const AdsCard({super.key});

  Future<void> _watch(BuildContext context) async {
    final ok = await context.read<AdsCubit>().watchToRemoveAds();
    if (!context.mounted || ok) return;
    CustomToast.show(context, 'ads.unavailable'.tr(), ToastType.info);
  }

  @override
  Widget build(BuildContext context) {
    if (!AdConfig.supported) return const SizedBox.shrink();
    return BlocBuilder<AdsCubit, AdsState>(
      builder: (context, s) {
        final now = DateTime.now();
        final until = s.adFreeUntil;
        final free = s.isAdFree(now);
        if (!s.ready && !free && !s.privacyOptionsRequired) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpace.md),
          child: SectionCard(
            title: 'ads.title'.tr(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  free && until != null
                      ? 'ads.freeUntil'.tr(
                          args: [
                            DateFormat.yMMMd(
                              context.locale.toString(),
                            ).add_jm().format(until),
                          ],
                        )
                      : 'ads.removeBody'.tr(),
                  style: AppText.bodySm.tinted(AppColors.textSecondary),
                ),
                if (!free && AdConfig.rewardedOn) ...[
                  const SizedBox(height: AppSpace.md),
                  AppButton(
                    label: 'ads.removeButton'.tr(),
                    icon: Icons.play_circle_outline,
                    kind: AppButtonKind.tonal,
                    onPressed: () => _watch(context),
                  ),
                ],
                if (s.privacyOptionsRequired) ...[
                  const SizedBox(height: AppSpace.sm),
                  AppButton(
                    label: 'ads.privacyChoices'.tr(),
                    kind: AppButtonKind.text,
                    onPressed: context.read<AdsCubit>().showPrivacyOptions,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
