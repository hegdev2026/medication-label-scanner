import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/common/widgets/brand_app_bar.dart';
import 'package:medicine_lab_reader/common/widgets/content_wrapper.dart';
import 'package:medicine_lab_reader/common/widgets/safety_notice.dart';
import 'package:medicine_lab_reader/common/widgets/section_card.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';
import 'package:medicine_lab_reader/features/settings/presentation/widgets/ads_card.dart';
import 'package:medicine_lab_reader/features/settings/presentation/widgets/app_version_label.dart';
import 'package:medicine_lab_reader/features/settings/presentation/widgets/cloud_scan_card.dart';
import 'package:medicine_lab_reader/features/settings/presentation/widgets/language_selector.dart';
import 'package:medicine_lab_reader/features/settings/presentation/widgets/legal_links_card.dart';
import 'package:medicine_lab_reader/features/settings/presentation/widgets/theme_selector.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: BrandAppBar(title: 'settings.title'.tr()),
    body: ContentWrapper(
      scrollable: true,
      child: Column(
        children: [
          const ThemeSelector(),
          const SizedBox(height: AppSpace.md),
          const LanguageSelector(),
          const SizedBox(height: AppSpace.md),
          const CloudScanCard(),
          const AdsCard(),
          SectionCard(
            title: 'settings.privacy'.tr(),
            child: Text('settings.privacyText'.tr()),
          ),
          const SizedBox(height: AppSpace.md),
          const LegalLinksCard(),
          const SizedBox(height: AppSpace.md),
          const SafetyNotice(),
          const AppVersionLabel(),
        ],
      ),
    ),
  );
}
