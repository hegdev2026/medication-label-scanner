import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/ads/app_open_gate.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/cloud_scan_settings.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/image_source_service.dart';

@LazySingleton(as: ImageSourceService)
class ImageSourceServiceImpl implements ImageSourceService {
  ImageSourceServiceImpl(
    this._picker,
    @Named('isMobile') this._isMobile,
    this._appOpenGate,
    this._cloud,
  );
  final ImagePicker _picker;
  final CloudScanSettings _cloud;
  final AppOpenGate _appOpenGate;
  final bool _isMobile;

  @override
  bool get cameraSupported => _isMobile;

  @override
  Future<String?> pick(ImageOrigin origin) async {
    // Coming back from the camera or gallery is not "opening" the app.
    _appOpenGate.leavingTemporarily();
    if (_isMobile) {
      final file = await _picker.pickImage(
        source: origin == ImageOrigin.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        // Small print needs pixels: full detail for on-device reading. Smart
        // scan's free plan takes 1 MB at most, so it gets a smaller photo.
        maxWidth: _cloud.available && _cloud.consent == true ? 2000 : 3200,
        imageQuality: _cloud.available && _cloud.consent == true ? 85 : 95,
      );
      return file?.path;
    }
    final file = await FilePicker.pickFile(type: FileType.image);
    return file?.path;
  }
}
