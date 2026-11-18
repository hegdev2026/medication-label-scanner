import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/common/widgets/ads/ad_banner.dart';
import 'package:medicine_lab_reader/common/widgets/brand_app_bar.dart';
import 'package:medicine_lab_reader/common/widgets/content_wrapper.dart';
import 'package:medicine_lab_reader/core/di/sl.dart';
import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/features/dashboard/presentation/bloc/dashboard_cubit.dart';
import 'package:medicine_lab_reader/features/dashboard/presentation/widgets/dashboard_skeleton.dart';
import 'package:medicine_lab_reader/features/dashboard/presentation/widgets/greeting_header.dart';
import 'package:medicine_lab_reader/features/dashboard/presentation/widgets/know_inside_card.dart';
import 'package:medicine_lab_reader/features/dashboard/presentation/widgets/quick_actions.dart';
import 'package:medicine_lab_reader/features/dashboard/presentation/widgets/recent_scans_section.dart';
import 'package:medicine_lab_reader/features/dashboard/presentation/widgets/scan_hero_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<DashboardCubit>()..start(),
    child: Scaffold(
      appBar: BrandAppBar(title: 'nav.home'.tr()),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, s) {
          if (s.loading) return const DashboardSkeleton();
          return ContentWrapper(
            scrollable: true,
            maxWidth: 720,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GreetingHeader(now: DateTime.now()),
                const SizedBox(height: AppSpace.lg),
                ScanHeroCard(onScan: () => context.push(AppRoutes.scan)),
                const SizedBox(height: AppSpace.xl),
                QuickActions(
                  onScan: () => context.push(AppRoutes.scan),
                  onImport: () => context.push(AppRoutes.scanGallery),
                  onLibrary: () => context.go(AppRoutes.inventory),
                ),
                const SizedBox(height: AppSpace.xl),
                RecentScansSection(
                  items: s.recent,
                  total: s.total,
                  onViewAll: () => context.go(AppRoutes.inventory),
                ),
                if (!s.infoDismissed) ...[
                  const SizedBox(height: AppSpace.xl),
                  KnowInsideCard(
                    onDismiss: context.read<DashboardCubit>().dismissInfo,
                  ),
                ],
                const SizedBox(height: AppSpace.lg),
                const AdBanner(),
              ],
            ),
          );
        },
      ),
    ),
  );
}
