import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/common/widgets/summary_tile.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/features/expiry/presentation/bloc/expiry_tracker_cubit.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/expiry_status.dart';

/// Three summary tiles (same look as the inventory's); each filters the list.
class ExpirySummary extends StatelessWidget {
  const ExpirySummary({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExpiryTrackerCubit>();
    return BlocBuilder<ExpiryTrackerCubit, ExpiryTrackerState>(
      buildWhen: (a, b) => a.groups != b.groups || a.filter != b.filter,
      builder: (context, s) {
        final soon =
            s.countFor(ExpiryStatus.within30) +
            s.countFor(ExpiryStatus.within60) +
            s.countFor(ExpiryStatus.within90);
        return Row(
          children: [
            Expanded(
              child: SummaryTile(
                icon: Icons.error_outline,
                color: AppColors.danger,
                value: s.countFor(ExpiryStatus.expired),
                label: 'expiry.expired'.tr(),
                selected: s.filter == ExpiryStatus.expired,
                onTap: () => cubit.setFilter(ExpiryStatus.expired),
              ),
            ),
            const SizedBox(width: AppSpace.sm),
            Expanded(
              child: SummaryTile(
                icon: Icons.alarm,
                color: AppColors.warning,
                value: soon,
                label: 'expiry.statSoon'.tr(),
                // Covers three chips, so it only filters via those.
                onTap: () => cubit.setFilter(ExpiryStatus.within30),
                selected:
                    s.filter == ExpiryStatus.within30 ||
                    s.filter == ExpiryStatus.within60 ||
                    s.filter == ExpiryStatus.within90,
              ),
            ),
            const SizedBox(width: AppSpace.sm),
            Expanded(
              child: SummaryTile(
                icon: Icons.help_outline,
                color: AppColors.textSecondary,
                value: s.countFor(ExpiryStatus.none),
                label: 'expiry.none'.tr(),
                selected: s.filter == ExpiryStatus.none,
                onTap: () => cubit.setFilter(ExpiryStatus.none),
              ),
            ),
          ],
        );
      },
    );
  }
}
