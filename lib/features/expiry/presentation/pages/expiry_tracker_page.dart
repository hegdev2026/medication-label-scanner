import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/common/widgets/brand_app_bar.dart';
import 'package:medicine_lab_reader/common/widgets/content_wrapper.dart';
import 'package:medicine_lab_reader/common/widgets/custom_toast.dart';
import 'package:medicine_lab_reader/common/widgets/delete_confirm_dialog.dart';
import 'package:medicine_lab_reader/common/widgets/empty_state.dart';
import 'package:medicine_lab_reader/common/widgets/skeleton_rows.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/di/sl.dart';
import 'package:medicine_lab_reader/core/error/failure_text.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/expiry/presentation/bloc/expiry_tracker_cubit.dart';
import 'package:medicine_lab_reader/features/expiry/presentation/widgets/expiry_filter_chips.dart';
import 'package:medicine_lab_reader/features/expiry/presentation/widgets/expiry_section.dart';
import 'package:medicine_lab_reader/features/expiry/presentation/widgets/expiry_summary.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_card_skeleton.dart';

/// Same layout as the inventory: brand bar, summary tiles, filter chips, then
/// the medicine cards, with the reminder note at the foot.
class ExpiryTrackerPage extends StatelessWidget {
  const ExpiryTrackerPage({super.key});

  Future<void> _confirmDelete(BuildContext context, Medicine m) async {
    final cubit = context.read<ExpiryTrackerCubit>();
    final ok = await showDeleteConfirmDialog(
      context,
      title: 'inventory.deleteTitle'.tr(args: [m.name]),
      message: 'inventory.deleteMsg'.tr(),
    );
    if (ok) cubit.delete(m);
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<ExpiryTrackerCubit>()..start(),
    child: BlocListener<ExpiryTrackerCubit, ExpiryTrackerState>(
      listenWhen: (a, b) => b.failure != null && a.failure != b.failure,
      listener: (context, s) {
        final f = s.failure;
        if (f != null) {
          CustomToast.show(context, failureText(f), ToastType.error);
        }
      },
      child: Scaffold(
        appBar: BrandAppBar(title: 'expiry.title'.tr()),
        body: BlocBuilder<ExpiryTrackerCubit, ExpiryTrackerState>(
          builder: (context, s) {
            if (s.loading) {
              return const ContentWrapper(
                scrollable: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SummaryRowSkeleton(),
                    SizedBox(height: AppSpace.sm),
                    ChipRowSkeleton(),
                    SizedBox(height: AppSpace.md),
                    MedicineListSkeleton(),
                  ],
                ),
              );
            }
            final empty = s.countFor(null) == 0;
            final sections = s.sections;
            return ContentWrapper(
              scrollable: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ExpirySummary(),
                  const SizedBox(height: AppSpace.sm),
                  const ExpiryFilterChips(),
                  const SizedBox(height: AppSpace.md),
                  if (empty)
                    EmptyState(
                      icon: Icons.event_available_outlined,
                      title: 'expiry.emptyTitle'.tr(),
                      message: 'expiry.emptyMsg'.tr(),
                    )
                  else if (sections.isEmpty)
                    EmptyState(
                      icon: Icons.filter_alt_off_outlined,
                      title: 'inventory.noMatchTitle'.tr(),
                      message: 'inventory.noMatchMsg'.tr(),
                    )
                  else
                    for (final st in sections)
                      ExpirySection(
                        status: st,
                        items: s.groups[st] ?? const [],
                        showHeading: s.filter == null,
                        onDelete: (m) => _confirmDelete(context, m),
                      ),
                  const SizedBox(height: AppSpace.sm),
                  AppSurface(
                    kind: AppSurfaceKind.inset,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSpace.sm),
                        Expanded(
                          child: Text(
                            'expiry.disclaimer'.tr(),
                            style: AppText.bodySm,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}
