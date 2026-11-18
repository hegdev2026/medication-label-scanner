import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/common/widgets/confirm_dialog.dart';
import 'package:medicine_lab_reader/common/widgets/custom_toast.dart';
import 'package:medicine_lab_reader/common/widgets/loading_view.dart';
import 'package:medicine_lab_reader/core/di/sl.dart';
import 'package:medicine_lab_reader/core/error/failure_text.dart';
import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/image_source_service.dart';
import 'package:medicine_lab_reader/features/scanner/presentation/bloc/scan_bloc.dart';
import 'package:medicine_lab_reader/features/scanner/presentation/widgets/scan_body.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key, this.initialOrigin});

  /// When set, the picker opens immediately (e.g. from "Import").
  final ImageOrigin? initialOrigin;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) {
      final bloc = sl<ScanBloc>();
      final origin = initialOrigin;
      if (origin != null) bloc.add(ScanRequested(origin));
      return bloc;
    },
    child: BlocConsumer<ScanBloc, ScanState>(
      listenWhen: (a, b) => a.status != b.status,
      listener: (context, s) async {
        final bloc = context.read<ScanBloc>();
        final draft = s.draft;
        if (s.status == ScanStatus.done && draft != null) {
          await context.push(AppRoutes.review, extra: draft);
          bloc.add(const ScanReset());
        } else if (s.status == ScanStatus.consentNeeded) {
          final origin = s.pendingOrigin;
          final allowed = await showConfirmDialog(
            context,
            title: 'scan.consentTitle'.tr(),
            message: 'scan.consentMsg'.tr(),
            confirmLabel: 'scan.consentAllow'.tr(),
            cancelLabel: 'scan.consentDeny'.tr(),
          );
          if (origin != null) {
            bloc.add(ScanConsentAnswered(allowed: allowed, origin: origin));
          }
        } else if (s.status == ScanStatus.failure) {
          final f = s.failure;
          if (f != null) {
            CustomToast.show(context, failureText(f), ToastType.error);
          }
        }
      },
      builder: (context, s) => Scaffold(
        appBar: AppBar(title: Text('scan.title'.tr())),
        body: s.status == ScanStatus.processing
            ? LoadingView(message: 'scan.reading'.tr())
            : const ScanBody(),
      ),
    ),
  );
}
