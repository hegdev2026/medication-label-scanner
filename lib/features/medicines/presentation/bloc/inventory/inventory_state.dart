part of 'inventory_bloc.dart';

enum InventorySort {
  recent('inventory.sortRecent'),
  name('inventory.sortName'),
  expiry('inventory.sortExpiry');

  const InventorySort(this.labelKey);
  final String labelKey;
}

/// Library filter chips: dosage-form groups plus an expiry shortcut.
enum InventoryFilter {
  all('inventory.all'),
  tablets('inventory.tablets'),
  capsules('inventory.capsules'),
  syrups('inventory.syrups'),
  topicals('inventory.topicals'),
  expiringSoon('inventory.expiringSoon');

  const InventoryFilter(this.labelKey);
  final String labelKey;

  bool matches(Medicine m, DateTime now) => switch (this) {
    InventoryFilter.all => true,
    InventoryFilter.tablets =>
      DosageCategoryResolver.of(m.dosageForm) == DosageCategory.tablet,
    InventoryFilter.capsules =>
      DosageCategoryResolver.of(m.dosageForm) == DosageCategory.capsule,
    InventoryFilter.syrups =>
      DosageCategoryResolver.of(m.dosageForm) == DosageCategory.syrup,
    InventoryFilter.topicals =>
      DosageCategoryResolver.of(m.dosageForm) == DosageCategory.topical,
    InventoryFilter.expiringSoon => switch (CheckExpiry.statusFor(
      m.expiryDate,
      now,
    )) {
      ExpiryStatus.within30 ||
      ExpiryStatus.within60 ||
      ExpiryStatus.within90 => true,
      _ => false,
    },
  };
}

enum InventoryViewMode { list, grid }

class InventoryState extends Equatable {
  const InventoryState({
    this.loading = true,
    this.all = const [],
    this.query = '',
    this.filter = InventoryFilter.all,
    this.view = InventoryViewMode.list,
    this.sort = InventorySort.recent,
    this.failure,
  });

  final bool loading;
  final List<Medicine> all;
  final String query;
  final InventoryFilter filter;
  final InventoryViewMode view;
  final InventorySort sort;
  final Failure? failure;

  /// How many saved medicines [f] would show (ignores search).
  int countFor(InventoryFilter f) {
    final now = DateTime.now();
    return all.where((m) => f.matches(m, now)).length;
  }

  /// Search + filter + sort applied to [all].
  List<Medicine> get visible {
    final q = query.trim().toLowerCase();
    final now = DateTime.now();
    final list = all.where((m) {
      if (!filter.matches(m, now)) return false;
      if (q.isEmpty) return true;
      return [
        m.name,
        m.genericName,
        m.strength,
        m.batchNumber,
        m.manufacturer,
      ].any((v) => v != null && v.toLowerCase().contains(q));
    }).toList();
    switch (sort) {
      case InventorySort.name:
        list.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
      case InventorySort.expiry:
        list.sort((a, b) {
          final x = a.expiryDate, y = b.expiryDate;
          if (x == null) return 1;
          if (y == null) return -1;
          return x.compareTo(y);
        });
      case InventorySort.recent:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return list;
  }

  InventoryState copyWith({
    bool? loading,
    List<Medicine>? all,
    String? query,
    InventoryFilter? filter,
    InventoryViewMode? view,
    InventorySort? sort,
    Failure? failure,
    bool clearFailure = false,
  }) => InventoryState(
    loading: loading ?? this.loading,
    all: all ?? this.all,
    query: query ?? this.query,
    filter: filter ?? this.filter,
    view: view ?? this.view,
    sort: sort ?? this.sort,
    failure: clearFailure ? null : (failure ?? this.failure),
  );

  @override
  List<Object?> get props => [loading, all, query, filter, view, sort, failure];
}
