import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/content_wrapper.dart';
import 'package:medicine_lab_reader/common/widgets/safety_notice.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/features/scanner/presentation/widgets/scan_panel.dart';
import 'package:medicine_lab_reader/features/scanner/presentation/widgets/scan_tips_card.dart';

class ScanBody extends StatelessWidget {
  const ScanBody({super.key});

  @override
  Widget build(BuildContext context) => const ContentWrapper(
    scrollable: true,
    maxWidth: 560,
    child: Column(
      children: [
        ScanPanel(),
        SizedBox(height: AppSpace.lg),
        ScanTipsCard(),
        SizedBox(height: AppSpace.md),
        SafetyNotice(),
      ],
    ),
  );
}
