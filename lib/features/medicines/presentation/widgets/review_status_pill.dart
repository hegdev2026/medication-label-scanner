import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_pill.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';

/// How the saved values came to be: confirmed, still to review, or typed in.
class ReviewStatusPill extends StatelessWidget {
  const ReviewStatusPill({super.key, required this.status});
  final ReviewStatus status;

  @override
  Widget build(BuildContext context) => switch (status) {
    ReviewStatus.confirmed => AppPill(
      label: 'details.reviewConfirmed'.tr(),
      tone: AppPillTone.mint,
      dot: true,
    ),
    ReviewStatus.needsReview => AppPill(
      label: 'details.reviewNeeds'.tr(),
      tone: AppPillTone.warning,
      icon: Icons.error_outline,
    ),
    ReviewStatus.manual => AppPill(
      label: 'details.reviewManual'.tr(),
      icon: Icons.keyboard_outlined,
    ),
  };
}
