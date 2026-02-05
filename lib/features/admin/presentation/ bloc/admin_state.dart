abstract class AdminState {}


class AdminInitial extends AdminState {}
class AdminLoading extends AdminState {}
class AdminDashboardLoaded extends AdminState {
  final dashboard;
  AdminDashboardLoaded(this.dashboard);
}
class AdminOrdersLoaded extends AdminState {
  final orders;
  AdminOrdersLoaded(this.orders);
}
class AdminError extends AdminState {
  final String message;
  AdminError(this.message);
}
// ✅ ADD THIS
class AdminInventoryLoaded extends AdminState {
  final List<dynamic> items;
  AdminInventoryLoaded(this.items);
}

class AdminProductSaving extends AdminState {}

class AdminProductSaved extends AdminState {}

class AdminProductError extends AdminState {
  final String message;
  AdminProductError(this.message);
}
