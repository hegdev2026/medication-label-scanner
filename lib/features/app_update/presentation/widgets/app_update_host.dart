import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/common/widgets/custom_toast.dart';
import 'package:medicine_lab_reader/core/router/navigator_keys.dart';
import 'package:medicine_lab_reader/features/app_update/presentation/bloc/app_update_cubit.dart';
import 'package:medicine_lab_reader/features/app_update/presentation/widgets/app_update_dialog.dart';

/// Shows the update prompts above the router (so dialogs open on the root
/// navigator) and asks Google Play again whenever the app returns to the front.
class AppUpdateHost extends StatefulWidget {
  const AppUpdateHost({super.key, required this.child});
  final Widget child;

  @override
  State<AppUpdateHost> createState() => _AppUpdateHostState();
}

// Holds only the lifecycle listener and a flag against stacking two dialogs;
// what is on offer lives in AppUpdateCubit.
class _AppUpdateHostState extends State<AppUpdateHost>
    with WidgetsBindingObserver {
  bool _asking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<AppUpdateCubit>().recheck();
    }
  }

  /// This sits above the navigator, so dialogs and toasts use its context.
  BuildContext? get _navigator => rootNavigatorKey.currentContext;

  Future<void> _onChange(BuildContext _, AppUpdateState s) async {
    final navigator = _navigator;
    if (navigator == null || !navigator.mounted) return;
    final cubit = context.read<AppUpdateCubit>();
    final mandatory = s.info?.mandatory ?? false;
    switch (s.status) {
      case AppUpdateStatus.available:
      case AppUpdateStatus.mandatory:
        if (_asking) return;
        _asking = true;
        final yes = await showAppUpdateDialog(
          navigator,
          prompt: AppUpdatePrompt.available,
          mandatory: mandatory,
        );
        _asking = false;
        if (yes) {
          await cubit.update();
        } else {
          cubit.dismiss();
        }
      case AppUpdateStatus.downloaded:
        if (_asking) return;
        _asking = true;
        final yes = await showAppUpdateDialog(
          navigator,
          prompt: AppUpdatePrompt.ready,
          mandatory: mandatory,
        );
        _asking = false;
        if (yes) {
          await cubit.restart();
        } else {
          cubit.dismiss();
        }
      case AppUpdateStatus.downloading:
        _toast(navigator, 'update.downloading'.tr(), ToastType.info);
      case AppUpdateStatus.failed:
        _toast(navigator, 'update.failed'.tr(), ToastType.error);
      case AppUpdateStatus.idle:
      case AppUpdateStatus.dismissed:
        break;
    }
  }

  void _toast(BuildContext navigator, String message, ToastType type) {
    // The overlay lives below the navigator, so look it up from there.
    final overlay = Navigator.maybeOf(navigator)?.overlay;
    final context = overlay?.context;
    if (context != null) CustomToast.show(context, message, type);
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<AppUpdateCubit, AppUpdateState>(
        listenWhen: (a, b) => a.status != b.status,
        listener: _onChange,
        child: widget.child,
      );
}
