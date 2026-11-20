import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/ads/ads_cubit.dart';
import 'package:medicine_lab_reader/core/app.dart';
import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/core/constants/app_assets.dart';
import 'package:medicine_lab_reader/core/di/sl.dart';
import 'package:medicine_lab_reader/core/services/orientation_policy.dart';
import 'package:medicine_lab_reader/features/app_update/presentation/bloc/app_update_cubit.dart';
import 'package:medicine_lab_reader/features/medicines/domain/usecase/request_notification_permission_usecase.dart';
import 'package:medicine_lab_reader/features/medicines/domain/usecase/reschedule_reminders_usecase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await OrientationPolicy.apply();
  await EasyLocalization.ensureInitialized();
  await configureDependencies();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('hi')],
      path: AppAssets.translationsDir,
      fallbackLocale: const Locale('en'),
      child: const MedScanApp(),
    ),
  );
  unawaited(_startServices());
}

/// Start-up work that must not block the first frame, in order: the
/// notification permission first, then reminders, then ad consent and the ad
/// SDK, then the update check (so its prompt never sits under a consent form).
Future<void> _startServices() async {
  await sl<RequestNotificationPermissionUsecase>()(const NoParams());
  await sl<RescheduleRemindersUsecase>()(const NoParams());
  final ads = sl<AdsCubit>();
  await ads.start();
  ads.observeLifecycle();
  await sl<AppUpdateCubit>().check();
}
