import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/common/widgets/app_surface.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/di/sl.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_info.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_info_query.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/bloc/medicine_info/medicine_info_cubit.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_info_card.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_info_skeleton.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/prescription_notes_card.dart';

/// Looks up general information for [medicine] and shows it, or a short note
/// when the name has no reliable match.
class MedicineInfoSection extends StatelessWidget {
  const MedicineInfoSection({
    super.key,
    required this.query,
    this.notFoundExtra,
    this.actionBuilder,
  });
  final MedicineInfoQuery query;

  /// Shown under the "no information" note, e.g. spelling suggestions.
  final Widget? notFoundExtra;

  /// An action shown under the result once loading is done, given the info
  /// found (null when there is none).
  final Widget Function(BuildContext context, MedicineInfo? info)?
  actionBuilder;

  @override
  Widget build(BuildContext context) => BlocProvider(
    key: ValueKey('${query.name}|${query.genericName}'),
    create: (_) => sl<MedicineInfoCubit>()..load(query),
    child: BlocBuilder<MedicineInfoCubit, MedicineInfoState>(
      builder: (context, s) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpace.md),
            child: _content(s),
          ),
          ..._action(context, s),
          const PrescriptionNotesCard(),
        ],
      ),
    ),
  );

  List<Widget> _action(BuildContext context, MedicineInfoState s) {
    final build = actionBuilder;
    if (build == null || s.status == MedicineInfoStatus.loading) {
      return const [];
    }
    return [build(context, s.info), const SizedBox(height: AppSpace.md)];
  }

  Widget _content(MedicineInfoState s) {
    final info = s.info;
    if (s.status == MedicineInfoStatus.loading) {
      return const MedicineInfoSkeleton();
    }
    if (info != null) return MedicineInfoCard(info: info);
    final extra = s.status == MedicineInfoStatus.notFound
        ? notFoundExtra
        : null;
    return AppSurface(
      kind: AppSurfaceKind.inset,
      padding: const EdgeInsets.all(AppSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 18, color: AppColors.textMuted),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  (s.status == MedicineInfoStatus.offline
                          ? 'info.offline'
                          : 'info.none')
                      .tr(),
                  style: AppText.bodySm.tinted(AppColors.textSecondary),
                ),
              ),
            ],
          ),
          ?extra,
        ],
      ),
    );
  }
}
