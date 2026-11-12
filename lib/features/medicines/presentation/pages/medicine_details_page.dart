import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/common/widgets/delete_confirm_dialog.dart';
import 'package:medicine_lab_reader/common/widgets/custom_toast.dart';
import 'package:medicine_lab_reader/common/widgets/empty_state.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_screen_skeletons.dart';
import 'package:medicine_lab_reader/core/di/sl.dart';
import 'package:medicine_lab_reader/core/error/failure_text.dart';
import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/bloc/medicine_details/medicine_details_cubit.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/details_action_dock.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_details_body.dart';

class MedicineDetailsPage extends StatelessWidget {
  const MedicineDetailsPage({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<MedicineDetailsCubit>()..load(id),
    child: BlocConsumer<MedicineDetailsCubit, MedicineDetailsState>(
      listener: (context, s) {
        if (s.deleted) context.go(AppRoutes.inventory);
        final f = s.failure;
        if (f != null) {
          CustomToast.show(context, failureText(f), ToastType.error);
        }
      },
      builder: (context, s) {
        final m = s.medicine;
        if (s.loading) {
          return Scaffold(
            appBar: AppBar(),
            body: const MedicineDetailsSkeleton(),
          );
        }
        if (m == null) {
          return Scaffold(
            appBar: AppBar(),
            body: EmptyState(
              icon: Icons.search_off,
              title: 'common.notFound'.tr(),
            ),
          );
        }
        final mid = m.id;
        return Scaffold(
          appBar: AppBar(
            title: Text('details.pageTitle'.tr(), style: AppText.titleMd),
            leading: BackButton(
              onPressed: () => context.canPop()
                  ? context.pop()
                  : context.go(AppRoutes.inventory),
            ),
          ),
          body: MedicineDetailsBody(medicine: m),
          bottomNavigationBar: DetailsActionDock(
            onScanAnother: () => context.push(AppRoutes.scan),
            onEdit: () {
              if (mid != null) context.push(AppRoutes.edit(mid));
            },
            onDelete: () async {
              final cubit = context.read<MedicineDetailsCubit>();
              final ok = await showDeleteConfirmDialog(
                context,
                title: 'details.deleteTitle'.tr(),
                message: 'details.deleteMsg'.tr(),
              );
              if (ok) cubit.delete();
            },
          ),
        );
      },
    ),
  );
}
