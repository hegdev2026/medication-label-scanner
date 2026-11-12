import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/common/adaptive/adaptive_view.dart';
import 'package:medicine_lab_reader/common/widgets/app_button.dart';
import 'package:medicine_lab_reader/common/widgets/confirm_dialog.dart';
import 'package:medicine_lab_reader/common/widgets/content_wrapper.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/bloc/medicine_form/medicine_form_cubit.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_form_controllers.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_form_fields.dart';
import 'package:medicine_lab_reader/features/medicines/presentation/widgets/medicine_image_panel.dart';
import 'package:medicine_lab_reader/features/scanner/domain/entities/extracted_details.dart';

/// Review / add / edit form. Holds only text controllers (ephemeral UI state);
/// saving goes through [MedicineFormCubit].
class MedicineFormBody extends StatefulWidget {
  const MedicineFormBody({super.key, this.existing, this.draft});
  final Medicine? existing;
  final ScanDraft? draft;

  @override
  State<MedicineFormBody> createState() => _MedicineFormBodyState();
}

class _MedicineFormBodyState extends State<MedicineFormBody> {
  final _formKey = GlobalKey<FormState>();
  late final MedicineFormControllers _controllers;

  bool get _fromScan => widget.draft != null;
  String? get _imagePath =>
      widget.existing?.imagePath ?? widget.draft?.imagePath;
  String get _rawText =>
      widget.existing?.rawOcrText ?? widget.draft?.rawText ?? '';

  @override
  void initState() {
    super.initState();
    _controllers = MedicineFormControllers(
      existing: widget.existing,
      details: widget.draft?.details,
    );
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) return;
    final cubit = context.read<MedicineFormCubit>();
    final expiry = _controllers.expiryDate;
    if (expiry != null && expiry.ambiguous) {
      final ok = await showConfirmDialog(
        context,
        title: 'form.confirmExpiryTitle'.tr(),
        message: 'form.confirmExpiryMsg'.tr(
          args: [
            expiry.original,
            DateFormat.yMMMM(
              context.locale.toString(),
            ).format(expiry.toDateTime()),
          ],
        ),
        confirmLabel: 'form.yesSave'.tr(),
      );
      if (!ok || !mounted) return;
    }
    cubit.submit(
      _controllers.toMedicine(
        existing: widget.existing,
        imagePath: _imagePath,
        rawText: _rawText,
        fromScan: _fromScan,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final details = widget.draft?.details;
    final fields = MedicineFormFields(
      formKey: _formKey,
      controllers: _controllers,
      flagged: details?.flagged ?? const {},
      warnings: details?.warnings ?? const [],
      nameCandidates: details?.nameCandidates ?? const [],
    );
    final image = MedicineImagePanel(imagePath: _imagePath, rawText: _rawText);
    final save = BlocBuilder<MedicineFormCubit, MedicineFormState>(
      builder: (context, s) => AppButton(
        label: (_fromScan ? 'form.confirmSave' : 'common.save').tr(),
        icon: Icons.check,
        loading: s.status == FormStatus.saving,
        onPressed: _submit,
      ),
    );
    final content = AdaptiveView(
      mobile: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          image,
          const SizedBox(height: AppSpace.lg),
          fields,
        ],
      ),
      tablet: (_) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: image),
          const SizedBox(width: AppSpace.xl),
          Expanded(flex: 3, child: fields),
        ],
      ),
    );
    return Column(
      children: [
        Expanded(
          child: ContentWrapper(
            scrollable: true,
            safeBottom: false,
            child: content,
          ),
        ),
        _SaveDock(child: save),
      ],
    );
  }
}

/// Save button pinned below the scrolling form, clear of the system bars.
class _SaveDock extends StatelessWidget {
  const _SaveDock({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // With the keyboard open there is little room left, so the dock gives its
    // space back to the form and returns once the keyboard closes.
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: keyboardOpen
          ? const SizedBox(width: double.infinity)
          : DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.card,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 20,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Center(
                  heightFactor: 1,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpace.margin),
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
