abstract class AdminEvent {}


class LoadDashboard extends AdminEvent {}
class LoadOrders extends AdminEvent {}

class LoadInventory extends AdminEvent {
  final String? status;
  final String? category;
  final String? search;

  LoadInventory({this.status, this.category, this.search});
}


class UpdateOrderStatus extends AdminEvent {
  final String id;
  final int status;
  UpdateOrderStatus(this.id, this.status);
}

class AddProduct extends AdminEvent {
  final String name;
  final String description;
  final String category;
  final double price;
  final int quantity;
  final List<String> images;

  AddProduct({
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.quantity,
    required this.images,
  });
}

class UpdateProduct extends AdminEvent {
  final String id;
  final String? name;
  final String? description;
  final String? category;
  final double? price;
  final int? quantity;
  final List<String>? images;

  UpdateProduct({
    required this.id,
    this.name,
    this.description,
    this.category,
    this.price,
    this.quantity,
    this.images,
  });
}
