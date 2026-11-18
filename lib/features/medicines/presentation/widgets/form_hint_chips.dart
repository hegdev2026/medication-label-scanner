import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/bloc/form_hints/form_hints_cubit.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_form_controllers.dart';

/// Tap-to-fill strength and dosage-form suggestions for a searched medicine.
/// Nothing is filled until the user taps, and nothing shows when no source
/// had anything.
class FormHintChips extends StatelessWidget {
  const FormHintChips({super.key, required this.controllers});
  final MedicineFormControllers controllers;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FormHintsCubit, FormHintsState>(
        builder: (context, s) {
          final h = s.hints;
          if (h.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(top: AppSpace.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'form.hints'.tr(),
                  style: AppText.bodySm.tinted(AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpace.xs),
                Wrap(
                  spacing: AppSpace.sm,
                  children: [
                    for (final v in h.strengths)
                      ActionChip(
                        label: Text(v),
                        onPressed: () => controllers.strength.text = v,
                      ),
                    for (final v in h.forms)
                      ActionChip(
                        label: Text(v),
                        onPressed: () => controllers.dosageForm.text = v,
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      );
}
