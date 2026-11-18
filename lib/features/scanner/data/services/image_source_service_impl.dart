import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/core/ads/app_open_gate.dart';
import 'package:medicine_lab_reader/features/scanner/domain/services/image_source_service.dart';

@LazySingleton(as: ImageSourceService)
class ImageSourceServiceImpl implements ImageSourceService {
  ImageSourceServiceImpl(
    this._picker,
    @Named('isMobile') this._isMobile,
    this._appOpenGate,
  );
  final ImagePicker _picker;
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
        // Sharp enough to read, small enough for the free online OCR (1 MB).
        maxWidth: 2000,
        imageQuality: 85,
      );
      return file?.path;
    }
    final file = await FilePicker.pickFile(type: FileType.image);
    return file?.path;
  }
}
