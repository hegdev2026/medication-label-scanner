import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/common/widgets/filter_pill.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/bloc/inventory/inventory_bloc.dart';

/// Horizontally scrolling filter pills with live counts.
class InventoryFilterChips extends StatelessWidget {
  const InventoryFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<InventoryBloc>();
    return SizedBox(
      height: 40,
      child: BlocBuilder<InventoryBloc, InventoryState>(
        buildWhen: (a, b) => a.filter != b.filter || a.all != b.all,
        builder: (context, s) => ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: InventoryFilter.values.length,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpace.sm),
          itemBuilder: (context, i) {
            final f = InventoryFilter.values[i];
            return FilterPill(
              label: f.labelKey.tr(),
              count: s.countFor(f),
              selected: s.filter == f,
              showDot: f == InventoryFilter.expiringSoon,
              onTap: () => bloc.add(InventoryFilterChanged(f)),
            );
          },
        ),
      ),
    );
  }
}
