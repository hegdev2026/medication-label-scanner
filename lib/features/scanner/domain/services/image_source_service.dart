enum ImageOrigin { camera, gallery }

abstract interface class ImageSourceService {
  bool get cameraSupported;

  /// Returns the picked image path, or null if the user cancelled.
  Future<String?> pick(ImageOrigin origin);
}
