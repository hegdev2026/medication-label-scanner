import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/common/widgets/section_card.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/di/sl.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/settings/presentation/bloc/cloud_scan_cubit.dart';

/// Switch for smart scan. Hidden when this build has no smart-scan server.
class CloudScanCard extends StatelessWidget {
  const CloudScanCard({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<CloudScanCubit>(),
    child: BlocBuilder<CloudScanCubit, CloudScanState>(
      builder: (context, s) {
        if (!s.available) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SectionCard(
            title: 'settings.cloudScan'.tr(),
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: s.enabled,
              onChanged: context.read<CloudScanCubit>().setEnabled,
              title: Text(
                'settings.cloudScanTitle'.tr(),
                style: AppText.bodyMd,
              ),
              subtitle: Text(
                'settings.cloudScanSub'.tr(),
                style: AppText.bodySm.tinted(AppColors.textSecondary),
              ),
            ),
          ),
        );
      },
    ),
  );
}
