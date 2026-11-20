import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'language_state.dart';

/// Language switch. Changing the language repaints the whole app, so the
/// choice is shown on the selector first and the repaint waits for the
/// selector's own animation to finish; otherwise the two compete for the same
/// frames and the switch stutters.
@injectable
class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const LanguageState());

  /// Long enough for the segmented button's selection animation.
  @visibleForTesting
  Duration settle = const Duration(milliseconds: 220);

  /// Adopts the language the app is already showing.
  void sync(String code) => emit(LanguageState(code: code));

  /// Marks [code] chosen now, then runs [apply] (which changes the app's
  /// language) once the selector has settled.
  Future<void> select(String code, Future<void> Function() apply) async {
    if (code == state.code) return;
    emit(LanguageState(code: code));
    await Future<void>.delayed(settle);
    if (isClosed) return;
    await apply();
  }
}
