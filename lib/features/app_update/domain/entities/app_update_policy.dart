/// When a newer version is not optional, and how it is delivered. The only
/// place that decides it.
abstract final class AppUpdatePolicy {
  /// Google Play's in-app update priority (0-5, set per release in the Play
  /// Developer API) from which an update is mandatory.
  static const int forcePriority = 4;

  /// Days a newer version may have been out, un-installed, before it becomes
  /// mandatory.
  static const int forceAfterDays = 30;

  static bool isMandatory({required int priority, int? stalenessDays}) =>
      priority >= forcePriority || (stalenessDays ?? 0) >= forceAfterDays;
}
