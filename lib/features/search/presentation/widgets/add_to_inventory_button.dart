import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/common/widgets/app_button.dart';
import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/features/medicines/domain/entities/medicine_seed.dart';

/// Opens the add form with the searched name filled in. The user adds the
/// expiry date, batch and the rest from the pack, and it saves through the
/// same duplicate check as every other medicine.
class AddToInventoryButton extends StatelessWidget {
  const AddToInventoryButton({super.key, required this.name, this.genericName});
  final String name;

  /// The proper name found by the lookup, when it differs from [name].
  final String? genericName;

  @override
  Widget build(BuildContext context) => AppButton(
    label: 'search.addToInventory'.tr(),
    icon: Icons.add_circle_outline,
    expand: true,
    onPressed: () => context.push(
      AppRoutes.medicineNew,
      extra: MedicineSeed(name: name, genericName: genericName),
    ),
  );
}
