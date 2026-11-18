import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/common/widgets/ads/ad_breaks.dart';
import 'package:medicine_lab_reader/common/widgets/confirm_dialog.dart';
import 'package:medicine_lab_reader/common/widgets/custom_toast.dart';
import 'package:medicine_lab_reader/common/widgets/empty_state.dart';
import 'package:medicine_lab_reader/core/di/sl.dart';
import 'package:medicine_lab_reader/core/error/failure_text.dart';
import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_seed.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/bloc/medicine_form/medicine_form_cubit.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_form_body.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_screen_skeletons.dart';
import 'package:medicine_lab_reader/features/scanner/domain/entities/extracted_details.dart';

/// Review after a scan, manual entry, or editing a saved medicine.
class MedicineFormPage extends StatelessWidget {
  const MedicineFormPage({super.key, this.medicineId, this.draft, this.seed});
  final int? medicineId;
  final ScanDraft? draft;
  final MedicineSeed? seed;

  String get _title => medicineId != null
      ? 'form.titleEdit'.tr()
      : (draft != null ? 'form.titleReview'.tr() : 'form.titleAdd'.tr());

  Future<void> _onState(BuildContext context, MedicineFormState s) async {
    final cubit = context.read<MedicineFormCubit>();
    switch (s.status) {
      case FormStatus.saved:
        final id = s.savedId;
        if (medicineId != null && context.canPop()) {
          context.pop();
        } else if (id != null) {
          context.go(AppRoutes.details(id));
          // A natural break after adding a medicine (never after an edit).
          if (medicineId == null) unawaited(runAdBreakAfterAdd());
        }
      case FormStatus.duplicateFound:
        final name = s.duplicates.isEmpty ? '' : s.duplicates.first.name;
        final ok = await showConfirmDialog(
          context,
          title: 'form.duplicateTitle'.tr(),
          message: 'form.duplicateMsg'.tr(args: [name]),
          confirmLabel: 'form.saveAnyway'.tr(),
        );
        if (ok) {
          await cubit.confirmDuplicate();
        } else {
          cubit.dismissDuplicate();
        }
      case FormStatus.failure:
        final f = s.failure;
        if (f != null) {
          CustomToast.show(context, failureText(f), ToastType.error);
        }
      case FormStatus.loading ||
          FormStatus.ready ||
          FormStatus.notFound ||
          FormStatus.saving:
    }
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<MedicineFormCubit>()..load(medicineId),
    child: BlocConsumer<MedicineFormCubit, MedicineFormState>(
      listenWhen: (a, b) => a.status != b.status,
      listener: _onState,
      buildWhen: (a, b) =>
          a.existing != b.existing ||
          a.status == FormStatus.loading ||
          b.status == FormStatus.notFound ||
          (b.status == FormStatus.failure && b.existing == null),
      builder: (context, s) => Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: switch (s.status) {
          FormStatus.loading => const MedicineFormSkeleton(),
          FormStatus.notFound => EmptyState(
            icon: Icons.search_off,
            title: 'common.notFound'.tr(),
          ),
          FormStatus.failure when medicineId != null && s.existing == null =>
            EmptyState(
              icon: Icons.error_outline,
              title: failureText(s.failure ?? const UnknownFailure()),
            ),
          _ => MedicineFormBody(existing: s.existing, draft: draft, seed: seed),
        },
      ),
    ),
  );
}
