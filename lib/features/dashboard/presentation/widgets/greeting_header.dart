import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

/// Time-of-day greeting. We never ask for or store a name.
class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key, required this.now});
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final hour = now.hour;
    final (key, icon) = hour < 12
        ? ('dashboard.greetMorning', Icons.wb_sunny_outlined)
        : hour < 17
        ? ('dashboard.greetAfternoon', Icons.wb_twilight_outlined)
        : ('dashboard.greetEvening', Icons.nights_stay_outlined);
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.inset,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Icon(icon, color: AppColors.accentText),
        ),
        const SizedBox(width: AppSpace.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(child: Text(key.tr(), style: AppText.titleMd)),
                  const SizedBox(width: 6),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.accentText,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              Text('dashboard.greetSub'.tr(), style: AppText.bodySm),
            ],
          ),
        ),
      ],
    );
  }
}
