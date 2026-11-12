import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/common/widgets/empty_state.dart';
import 'package:medicine_lab_reader/common/widgets/section_card.dart';
import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_tile.dart';

class RecentMedicinesCard extends StatelessWidget {
  const RecentMedicinesCard({super.key, required this.items});
  final List<Medicine> items;

  @override
  Widget build(BuildContext context) => SectionCard(
    title: 'dashboard.recent'.tr(),
    child: items.isEmpty
        ? EmptyState(
            icon: Icons.document_scanner_outlined,
            title: 'dashboard.emptyTitle'.tr(),
            message: 'dashboard.emptyMsg'.tr(),
          )
        : Column(
            children: [
              for (final m in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpace.sm),
                  child: MedicineTile(
                    medicine: m,
                    onTap: () {
                      final id = m.id;
                      if (id != null) context.push(AppRoutes.details(id));
                    },
                  ),
                ),
            ],
          ),
  );
}
