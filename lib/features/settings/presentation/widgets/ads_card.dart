import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/common/widgets/app_button.dart';
import 'package:medicine_lab_reader/common/widgets/section_card.dart';
import 'package:medicine_lab_reader/core/ads/ads_cubit.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

/// Settings: lets users in regions where the law requires it change their ad
/// privacy choices. Hidden for everyone else.
class AdsCard extends StatelessWidget {
  const AdsCard({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<AdsCubit, AdsState>(
    buildWhen: (a, b) => a.privacyOptionsRequired != b.privacyOptionsRequired,
    builder: (context, s) {
      if (!s.privacyOptionsRequired) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpace.md),
        child: SectionCard(
          title: 'ads.title'.tr(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ads.about'.tr(),
                style: AppText.bodySm.tinted(AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpace.md),
              AppButton(
                label: 'ads.privacyChoices'.tr(),
                kind: AppButtonKind.tonal,
                onPressed: context.read<AdsCubit>().showPrivacyOptions,
              ),
            ],
          ),
        ),
      );
    },
  );
}
