import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/bubble_menu.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';

/// Reusable three-dot button. Its menu points at the button, opens where there
/// is room ([showBubbleMenu]) and looks iPhone-style or Material by platform.
/// [onSelected] gets the chosen item's value.
class ActionMenuButton<T> extends StatelessWidget {
  const ActionMenuButton({
    super.key,
    required this.items,
    required this.onSelected,
    this.tooltip,
    this.enabled = true,
    this.size = 36,
    this.icon = Icons.more_vert_rounded,
  });

  final List<BubbleMenuItem<T>> items;
  final ValueChanged<T> onSelected;
  final String? tooltip;

  /// Off, the button is dimmed and does nothing.
  final bool enabled;
  final double size;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Builder(
    builder: (anchor) {
      final button = Opacity(
        opacity: enabled ? 1 : 0.4,
        child: Material(
          color: AppColors.inset,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: BorderSide(color: AppColors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: !enabled
                ? null
                : () async {
                    final picked = await showBubbleMenu<T>(
                      anchor,
                      items: items,
                    );
                    if (picked != null) onSelected(picked);
                  },
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(icon, size: 20, color: AppColors.textPrimary),
            ),
          ),
        ),
      );
      final label = tooltip;
      return label == null ? button : Tooltip(message: label, child: button);
    },
  );
}
