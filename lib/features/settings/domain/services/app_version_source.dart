/// The installed app's version, e.g. `1.0.0 (1)`. Null when it cannot be read.
abstract interface class AppVersionSource {
  Future<String?> read();
}
