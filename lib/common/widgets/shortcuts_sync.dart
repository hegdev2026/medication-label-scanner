import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

import 'package:medicine_lab_reader/core/di/sl.dart';
import 'package:medicine_lab_reader/core/services/app_shortcuts_service.dart';

/// Keeps the launcher shortcuts' titles in the app's language: publishes them
/// at start and again whenever the language changes.
class ShortcutsSync extends StatefulWidget {
  const ShortcutsSync({super.key, required this.child});
  final Widget child;

  @override
  State<ShortcutsSync> createState() => _ShortcutsSyncState();
}

class _ShortcutsSyncState extends State<ShortcutsSync> {
  Locale? _published;

  @override
  void initState() {
    super.initState();
    sl<AppShortcutsService>().init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = context.locale;
    if (_published == locale) return;
    _published = locale;
    // Wait a frame so the new language's strings are loaded.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<AppShortcutsService>().setTitles(
        scanTitle: 'shortcuts.scan'.tr(),
        addTitle: 'shortcuts.add'.tr(),
        searchTitle: 'shortcuts.search'.tr(),
        expiryTitle: 'shortcuts.expiry'.tr(),
      );
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
