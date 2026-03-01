abstract class OrdersEvent {}

class LoadOrders extends OrdersEvent {}

class SearchOrders extends OrdersEvent {
  final String query;
  SearchOrders(this.query);
}

class FilterOrdersByTab extends OrdersEvent {
  final OrderFilterTab tab;
  FilterOrdersByTab(this.tab);
}

class LoadOrderDetails extends OrdersEvent {
  final String orderId;
  LoadOrderDetails(this.orderId);
}

enum OrderFilterTab { all, ongoing, completed, cancelled }
