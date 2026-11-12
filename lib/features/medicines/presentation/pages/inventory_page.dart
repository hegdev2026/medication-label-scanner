import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/common/widgets/brand_app_bar.dart';
import 'package:medicine_lab_reader/common/widgets/content_wrapper.dart';
import 'package:medicine_lab_reader/common/widgets/custom_toast.dart';
import 'package:medicine_lab_reader/core/di/sl.dart';
import 'package:medicine_lab_reader/core/error/failure_text.dart';
import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/bloc/inventory/inventory_bloc.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/inventory_filter_chips.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/inventory_header.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/inventory_list.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/inventory_search_bar.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/inventory_toolbar.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/older_labels_banner.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<InventoryBloc>()..add(const InventoryStarted()),
    child: BlocListener<InventoryBloc, InventoryState>(
      listenWhen: (a, b) => b.failure != null && a.failure != b.failure,
      listener: (context, s) {
        final f = s.failure;
        if (f != null) {
          CustomToast.show(context, failureText(f), ToastType.error);
        }
      },
      child: Scaffold(
        appBar: BrandAppBar(title: 'inventory.appBarTitle'.tr()),
        body: ContentWrapper(
          scrollable: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const InventoryHeader(),
              const SizedBox(height: AppSpace.sm),
              InventorySearchBar(onAddScan: () => context.push(AppRoutes.scan)),
              const SizedBox(height: AppSpace.sm),
              const InventoryFilterChips(),
              const SizedBox(height: AppSpace.sm),
              const InventoryToolbar(),
              const SizedBox(height: AppSpace.sm),
              const InventoryList(),
              const SizedBox(height: AppSpace.lg),
              OlderLabelsBanner(onTap: () => context.go(AppRoutes.expiry)),
            ],
          ),
        ),
      ),
    ),
  );
}
