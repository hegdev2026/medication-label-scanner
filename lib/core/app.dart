import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medicine_lab_reader/core/ads/ads_cubit.dart';
import 'package:medicine_lab_reader/core/di/sl.dart';
import 'package:medicine_lab_reader/core/router/app_router.dart';
import 'package:medicine_lab_reader/core/theme/app_theme.dart';
import 'package:medicine_lab_reader/core/theme/theme_cubit.dart';
import 'package:medicine_lab_reader/core/theme/theme_scope.dart';

class MedScanApp extends StatelessWidget {
  const MedScanApp({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider.value(value: sl<ThemeCubit>()),
      BlocProvider.value(value: sl<AdsCubit>()),
    ],
    child: BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, theme) => ThemeScope(
        palette: theme.palette,
        locale: context.locale,
        child: MaterialApp.router(
          title: 'app.title'.tr(),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.of(theme.palette),
          themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
          darkTheme: AppTheme.of(theme.palette),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          routerConfig: sl<AppRouter>().config,
          // Tapping anywhere outside a text field drops its focus (and the
          // cursor and keyboard with it).
          builder: (context, child) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: child,
          ),
        ),
      ),
    ),
  );
}
