import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/app_text_field.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';
import 'package:medicine_lab_reader/features/medicines/domain/value_objects/printed_date.dart';

/// Printed-date input with calendar picker and a live "read as" explanation.
class DateInputField extends StatelessWidget {
  const DateInputField({
    super.key,
    required this.controller,
    required this.label,
    this.needsReview = false,
  });
  final TextEditingController controller;
  final String label;
  final bool needsReview;

  String? _validate(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    return PrintedDate.parse(v) == null ? 'form.dateInvalid'.tr() : null;
  }

  Future<void> _pick(BuildContext context) async {
    final initial =
        PrintedDate.parse(controller.text)?.toDateTime() ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) controller.text = DateFormat('MM/yyyy').format(picked);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: controller,
          label: label,
          hint: 'MM/YYYY',
          icon: Icons.event_outlined,
          needsReview: needsReview,
          validator: _validate,
          suffix: IconButton(
            icon: const Icon(Icons.edit_calendar_outlined),
            tooltip: 'form.pickDate'.tr(),
            onPressed: () => _pick(context),
          ),
        ),
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final p = PrintedDate.parse(controller.text);
            if (p == null) return const SizedBox.shrink();
            final fmt = p.isMonthOnly
                ? DateFormat.yMMMM(locale)
                : DateFormat.yMMMd(locale);
            final text =
                'form.readAs'.tr(args: [fmt.format(p.toDateTime())]) +
                (p.isMonthOnly ? ' ${'form.endOfMonth'.tr()}' : '') +
                (p.ambiguous ? ' – ${'form.pleaseConfirm'.tr()}' : '');
            return Padding(
              padding: const EdgeInsets.only(top: 6, left: 8),
              child: Text(text, style: AppText.bodySm),
            );
          },
        ),
      ],
    );
  }
}
