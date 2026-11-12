import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:medicine_lab_reader/core/theme/app_palette.dart';

part 'theme_state.dart';

/// Owns the chosen theme mode, persists it and follows the OS brightness.
@lazySingleton
class ThemeCubit extends Cubit<ThemeState> with WidgetsBindingObserver {
  ThemeCubit(this._prefs)
    : super(
        ThemeState(
          mode: _read(_prefs),
          platformBrightness:
              WidgetsBinding.instance.platformDispatcher.platformBrightness,
        ),
      ) {
    WidgetsBinding.instance.addObserver(this);
  }

  final SharedPreferences _prefs;
  static const _key = 'theme_mode';

  static ThemeMode _read(SharedPreferences p) => ThemeMode.values.firstWhere(
    (m) => m.name == p.getString(_key),
    orElse: () => ThemeMode.system,
  );

  Future<void> setMode(ThemeMode mode) async {
    emit(state.copyWith(mode: mode));
    await _prefs.setString(_key, mode.name);
  }

  @override
  void didChangePlatformBrightness() => emit(
    state.copyWith(
      platformBrightness:
          WidgetsBinding.instance.platformDispatcher.platformBrightness,
    ),
  );

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
