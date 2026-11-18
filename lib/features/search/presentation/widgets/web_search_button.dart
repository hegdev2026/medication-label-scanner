import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:medicine_lab_reader/common/widgets/app_button.dart';
import 'package:medicine_lab_reader/core/theme/app_metrics.dart';

/// Last resort for a name no free medicine source knows: opens the user's own
/// browser on a web search. The app itself sends nothing.
class WebSearchButton extends StatelessWidget {
  const WebSearchButton({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpace.md),
    child: AppButton(
      label: 'search.webSearch'.tr(args: [name]),
      icon: Icons.travel_explore,
      kind: AppButtonKind.tonal,
      expand: true,
      onPressed: () => launchUrl(
        Uri.https('www.google.com', '/search', {'q': '$name medicine'}),
        mode: LaunchMode.externalApplication,
      ),
    ),
  );
}
