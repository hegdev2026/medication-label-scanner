import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/features/scanner/domain/services/cloud_scan_settings.dart';

part 'cloud_scan_state.dart';

@injectable
class CloudScanCubit extends Cubit<CloudScanState> {
  CloudScanCubit(this._settings)
    : super(
        CloudScanState(
          available: _settings.available,
          enabled: _settings.consent ?? false,
        ),
      );
  final CloudScanSettings _settings;

  Future<void> setEnabled(bool value) async {
    await _settings.setConsent(allowed: value);
    emit(CloudScanState(available: state.available, enabled: value));
  }
}
