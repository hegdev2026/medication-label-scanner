import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:medicine_lab_reader/core/ads/ads_cubit.dart';
import 'package:medicine_lab_reader/core/app.dart';
import 'package:medicine_lab_reader/core/base/base_usecase.dart';
import 'package:medicine_lab_reader/core/constants/app_assets.dart';
import 'package:medicine_lab_reader/core/di/sl.dart';
import 'package:medicine_lab_reader/features/medicines/domain/usecase/reschedule_reminders_usecase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  sl<RescheduleRemindersUsecase>()(const NoParams());
  unawaited(
    sl<AdsCubit>().start().then((_) => sl<AdsCubit>().observeLifecycle()),
  );
}
