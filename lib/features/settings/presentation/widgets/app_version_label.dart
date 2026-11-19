import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/di/sl.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/settings/presentation/bloc/app_version_cubit.dart';

/// "Version 1.0.0 (1)" at the foot of Settings. Shows nothing until it is read.
class AppVersionLabel extends StatelessWidget {
  const AppVersionLabel({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<AppVersionCubit>()..load(),
    child: BlocBuilder<AppVersionCubit, AppVersionState>(
      builder: (context, s) {
        final version = s.version;
        if (version == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpace.lg),
          child: Center(
            child: Text(
              'settings.version'.tr(args: [version]),
              style: AppText.labelSm.regular.tinted(AppColors.textMuted),
            ),
          ),
        );
      },
    ),
  );
}
