part of 'inventory_bloc.dart';

sealed class InventoryEvent {
  const InventoryEvent();
}

class InventoryStarted extends InventoryEvent {
  const InventoryStarted();
}

class InventoryUpdated extends InventoryEvent {
  const InventoryUpdated(this.items);
  final List<Medicine> items;
}

class InventorySearchChanged extends InventoryEvent {
  const InventorySearchChanged(this.query);
  final String query;
}

class InventoryFilterChanged extends InventoryEvent {
  const InventoryFilterChanged(this.filter);
  final InventoryFilter filter;
}

class InventoryViewChanged extends InventoryEvent {
  const InventoryViewChanged(this.view);
  final InventoryViewMode view;
}

class InventorySortChanged extends InventoryEvent {
  const InventorySortChanged(this.sort);
  final InventorySort sort;
}

class InventoryDeleted extends InventoryEvent {
  const InventoryDeleted(this.medicine);
  final Medicine medicine;
}
