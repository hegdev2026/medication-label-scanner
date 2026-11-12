import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/features/shell/presentation/widgets/nav_destinations.dart';
import 'package:medicine_lab_reader/features/shell/presentation/widgets/nav_scan_button.dart';

class SideRail extends StatelessWidget {
  const SideRail({
    super.key,
    required this.index,
    required this.onSelected,
    required this.extended,
    required this.onScan,
  });
  final int index;
  final ValueChanged<int> onSelected;
  final bool extended;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) => NavigationRail(
    extended: extended,
    leading: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.lg),
      child: NavScanButton(onTap: onScan),
    ),
    selectedIndex: index,
    onDestinationSelected: onSelected,
    labelType: extended
        ? NavigationRailLabelType.none
        : NavigationRailLabelType.all,
    destinations: [
      for (final d in navDestinations)
        NavigationRailDestination(
          icon: Icon(d.icon),
          selectedIcon: Icon(d.selectedIcon),
          label: Text(d.labelKey.tr()),
        ),
    ],
  );
}
