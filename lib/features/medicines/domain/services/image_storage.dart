abstract interface class ImageStorage {
  /// Copies the image into app-private storage and returns the new path.
  /// If [sourcePath] is already private it is returned unchanged.
  Future<String> persist(String sourcePath);
  Future<void> delete(String? path);
}
