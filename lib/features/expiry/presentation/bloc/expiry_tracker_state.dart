part of 'expiry_tracker_cubit.dart';

class ExpiryTrackerState extends Equatable {
  const ExpiryTrackerState({
    this.loading = true,
    this.groups = const {},
    this.filter,
    this.failure,
  });
  final bool loading;

  /// Medicines by expiry status (only the statuses the tracker shows).
  final Map<ExpiryStatus, List<Medicine>> groups;

  /// The status chip in use; null shows every tracked status.
  final ExpiryStatus? filter;
  final Failure? failure;

  int countFor(ExpiryStatus? s) => s == null
      ? groups.values.fold(0, (n, l) => n + l.length)
      : (groups[s]?.length ?? 0);

  /// Statuses to list, in tracker order, after applying [filter].
  List<ExpiryStatus> get sections => [
    for (final s in ExpiryTrackerCubit.order)
      if ((filter == null || filter == s) && (groups[s] ?? const []).isNotEmpty)
        s,
  ];

  ExpiryTrackerState copyWith({
    bool? loading,
    Map<ExpiryStatus, List<Medicine>>? groups,
    ExpiryStatus? filter,
    bool clearFilter = false,
    Failure? failure,
    bool clearFailure = false,
  }) => ExpiryTrackerState(
    loading: loading ?? this.loading,
    groups: groups ?? this.groups,
    filter: clearFilter ? null : (filter ?? this.filter),
    failure: clearFailure ? null : (failure ?? this.failure),
  );

  @override
  List<Object?> get props => [loading, groups, filter, failure];
}
