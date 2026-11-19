import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/features/settings/domain/services/app_version_source.dart';

part 'app_version_state.dart';

@injectable
class AppVersionCubit extends Cubit<AppVersionState> {
  AppVersionCubit(this._source) : super(const AppVersionState());
  final AppVersionSource _source;

  Future<void> load() async {
    final version = await _source.read();
    if (isClosed) return;
    emit(AppVersionState(version: version));
  }
}
