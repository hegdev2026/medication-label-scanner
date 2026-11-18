import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/common/adaptive/adaptive_view.dart';
import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/features/shell/presentation/widgets/mobile_bottom_nav.dart';
import 'package:medicine_lab_reader/features/shell/presentation/widgets/nav_scan_button.dart';
import 'package:medicine_lab_reader/features/shell/presentation/widgets/side_rail.dart';

/// Adaptive shell: bottom bar on mobile, rail on tablet, extended rail on desktop.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  void _go(int i) =>
      shell.goBranch(i, initialLocation: i == shell.currentIndex);

  void _scan(BuildContext context) => context.push(AppRoutes.scan);

  Widget _withRail(BuildContext context, {required bool extended}) => Scaffold(
    body: Row(
      children: [
        SideRail(
          index: shell.currentIndex,
          onSelected: _go,
          extended: extended,
          onScan: () => _scan(context),
        ),
        const VerticalDivider(width: 1),
        Expanded(child: shell),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => AdaptiveView(
    mobile: (context) => Scaffold(
      body: shell,
      // Sits above the floating bar, at the end of the screen.
      floatingActionButton: NavScanButton(onTap: () => _scan(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: MobileBottomNav(
        index: shell.currentIndex,
        onSelected: _go,
      ),
    ),
    tablet: (context) => _withRail(context, extended: false),
    desktop: (context) => _withRail(context, extended: true),
  );
}
