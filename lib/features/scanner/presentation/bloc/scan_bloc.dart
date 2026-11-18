import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/error/failures.dart';
import 'package:medicine_lab_reader/features/scanner/domain/entities/extracted_details.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/cloud_scan_settings.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/image_source_service.dart';
import 'package:medicine_lab_reader/features/scanner/domain/usecase/pick_image_usecase.dart';
import 'package:medicine_lab_reader/features/scanner/domain/usecase/scan_medicine_usecase.dart';

part 'scan_event.dart';
part 'scan_state.dart';

@injectable
class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc(this._pick, this._scan, this._cloud) : super(const ScanState()) {
    on<ScanRequested>(_onRequested);
    on<ScanConsentAnswered>(_onConsent);
    on<ScanReset>((_, emit) => emit(const ScanState()));
  }

  final PickImageUsecase _pick;
  final ScanMedicineUsecase _scan;
  final CloudScanSettings _cloud;

  bool get cameraSupported => _pick.cameraSupported;

  Future<void> _onConsent(
    ScanConsentAnswered e,
    Emitter<ScanState> emit,
  ) async {
    await _cloud.setConsent(allowed: e.allowed);
    add(ScanRequested(e.origin));
  }

  Future<void> _onRequested(ScanRequested e, Emitter<ScanState> emit) async {
    // Ask once, before any photo can leave the device.
    if (_cloud.available && _cloud.consent == null) {
      emit(
        ScanState(status: ScanStatus.consentNeeded, pendingOrigin: e.origin),
      );
      return;
    }
    final picked = await _pick(e.origin);
    final path = picked.fold<String?>((f) {
      emit(ScanState(status: ScanStatus.failure, failure: f));
      return null;
    }, (p) => p);
    if (path == null) return; // cancelled or failed

    emit(const ScanState(status: ScanStatus.processing));
    final result = await _scan(path);
    result.fold(
      (f) => emit(
        f is OcrUnavailableFailure
            // Let the user continue with manual entry.
            ? ScanState(
                status: ScanStatus.done,
                draft: ScanDraft(
                  imagePath: path,
                  rawText: '',
                  details: const ExtractedDetails(
                    warnings: [ExtractionWarning.ocrUnavailable],
                  ),
                ),
              )
            : ScanState(status: ScanStatus.failure, failure: f),
      ),
      (draft) => emit(ScanState(status: ScanStatus.done, draft: draft)),
    );
  }
}
