import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:medicine_lab_reader/common/widgets/section_card.dart';
import 'package:medicine_lab_reader/core/constants/app_colors.dart';
import 'package:medicine_lab_reader/core/router/app_routes.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/core/theme/app_typography.dart';

/// Settings card linking to the Terms of Service and the Privacy Policy.
class LegalLinksCard extends StatelessWidget {
  const LegalLinksCard({super.key});

  @override
  Widget build(BuildContext context) => SectionCard(
    title: 'legal.settingsTitle'.tr(),
    child: Column(
      children: [
        _LinkRow(
          icon: Icons.description_outlined,
          label: 'legal.termsTitle'.tr(),
          onTap: () => context.push(AppRoutes.terms),
        ),
        Divider(height: 1, color: AppColors.border),
        _LinkRow(
          icon: Icons.privacy_tip_outlined,
          label: 'legal.privacyTitle'.tr(),
          onTap: () => context.push(AppRoutes.privacy),
        ),
      ],
    ),
  );
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(AppRadius.lg),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.md),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.accentText),
          const SizedBox(width: AppSpace.md),
          Expanded(child: Text(label, style: AppText.titleSm)),
          Icon(Icons.chevron_right, color: AppColors.textMuted),
        ],
      ),
    ),
  );
}
