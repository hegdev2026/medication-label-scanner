part of 'dashboard_cubit.dart';

class DashboardState extends Equatable {
  const DashboardState({
    this.loading = true,
    this.total = 0,
    this.expired = 0,
    this.expiringSoon = 0,
    this.recent = const [],
    this.infoDismissed = false,
  });

  final bool loading;
  final int total, expired, expiringSoon;
  final List<Medicine> recent;

  /// The "Know what's inside" tip was closed this session.
  final bool infoDismissed;

  DashboardState copyWith({
    bool? loading,
    int? total,
    int? expired,
    int? expiringSoon,
    List<Medicine>? recent,
    bool? infoDismissed,
  }) => DashboardState(
    loading: loading ?? this.loading,
    total: total ?? this.total,
    expired: expired ?? this.expired,
    expiringSoon: expiringSoon ?? this.expiringSoon,
    recent: recent ?? this.recent,
    infoDismissed: infoDismissed ?? this.infoDismissed,
  );

  @override
  List<Object?> get props => [
    loading,
    total,
    expired,
    expiringSoon,
    recent,
    infoDismissed,
  ];
}
