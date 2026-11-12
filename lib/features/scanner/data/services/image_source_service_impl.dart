import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import 'package:medicine_lab_reader/features/scanner/domain/services/image_source_service.dart';

@LazySingleton(as: ImageSourceService)
class ImageSourceServiceImpl implements ImageSourceService {
  ImageSourceServiceImpl(this._picker, @Named('isMobile') this._isMobile);
  final ImagePicker _picker;
  final bool _isMobile;

  @override
  bool get cameraSupported => _isMobile;

  @override
  Future<String?> pick(ImageOrigin origin) async {
    if (_isMobile) {
      final file = await _picker.pickImage(
        source: origin == ImageOrigin.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        maxWidth: 2400,
      );
      return file?.path;
    }
    final file = await FilePicker.pickFile(type: FileType.image);
    return file?.path;
  }
}
