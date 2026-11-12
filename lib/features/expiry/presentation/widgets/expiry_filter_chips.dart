import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/common/widgets/filter_pill.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/features/expiry/presentation/bloc/expiry_tracker_cubit.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/expiry_status.dart';

/// Horizontally scrolling filter pills with live counts (All + each status).
class ExpiryFilterChips extends StatelessWidget {
  const ExpiryFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExpiryTrackerCubit>();
    final options = <ExpiryStatus?>[null, ...ExpiryTrackerCubit.order];
    return SizedBox(
      height: 40,
      child: BlocBuilder<ExpiryTrackerCubit, ExpiryTrackerState>(
        buildWhen: (a, b) => a.filter != b.filter || a.groups != b.groups,
        builder: (context, s) => ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: options.length,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpace.sm),
          itemBuilder: (context, i) {
            final o = options[i];
            return FilterPill(
              label: (o?.labelKey ?? 'expiry.all').tr(),
              count: s.countFor(o),
              selected: s.filter == o,
              showDot: o == ExpiryStatus.expired,
              dotColor: AppColors.danger,
              onTap: () => cubit.setFilter(o),
            );
          },
        ),
      ),
    );
  }
}
