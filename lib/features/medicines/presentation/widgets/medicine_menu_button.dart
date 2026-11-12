import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/action_menu_button.dart';
import 'package:medicine_lab_reader/common/widgets/bubble_menu.dart';

enum MedicineMenuAction { edit, delete }

/// Three-dot quick actions on a medicine card.
class MedicineMenuButton extends StatelessWidget {
  const MedicineMenuButton({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });
  final VoidCallback onEdit, onDelete;

  @override
  Widget build(BuildContext context) => ActionMenuButton<MedicineMenuAction>(
    tooltip: 'common.more'.tr(),
    size: 32,
    items: [
      BubbleMenuItem(
        value: MedicineMenuAction.edit,
        icon: Icons.edit_outlined,
        label: 'common.edit'.tr(),
      ),
      BubbleMenuItem(
        value: MedicineMenuAction.delete,
        icon: Icons.delete_outline,
        label: 'common.delete'.tr(),
        danger: true,
      ),
    ],
    onSelected: (a) => switch (a) {
      MedicineMenuAction.edit => onEdit(),
      MedicineMenuAction.delete => onDelete(),
    },
  );
}
