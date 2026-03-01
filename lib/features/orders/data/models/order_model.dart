class OrderProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final int quantity;

  const OrderProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.quantity,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>? ?? {};

    return OrderProductModel(
      id: product['_id']?.toString() ?? '',
      name: product['name']?.toString() ?? 'Product',
      description: product['description']?.toString() ?? '',
      price: (product['price'] as num?)?.toDouble() ?? 0,
      images: (product['images'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}

class OrderStatusHistoryModel {
  final int status;
  final String statusName;
  final DateTime timestamp;

  const OrderStatusHistoryModel({
    required this.status,
    required this.statusName,
    required this.timestamp,
  });

  factory OrderStatusHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusHistoryModel(
      status: (json['status'] as num?)?.toInt() ?? 0,
      statusName: json['statusName']?.toString() ?? 'Pending',
      timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

class OrderModel {
  final String id;
  final List<OrderProductModel> products;
  final double totalPrice;
  final String address;
  final int status;
  final DateTime orderedAt;
  final List<OrderStatusHistoryModel> statusHistory;

  const OrderModel({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.address,
    required this.status,
    required this.orderedAt,
    required this.statusHistory,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id']?.toString() ?? '',
      products: (json['products'] as List<dynamic>? ?? const [])
          .map((e) => OrderProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0,
      address: json['address']?.toString() ?? '',
      status: (json['status'] as num?)?.toInt() ?? 0,
      orderedAt: DateTime.fromMillisecondsSinceEpoch(
        (json['orderedAt'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
      ),
      statusHistory: (json['statusHistory'] as List<dynamic>? ?? const [])
          .map((e) =>
              OrderStatusHistoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String get statusLabel {
    switch (status) {
      case 1:
        return 'Confirmed';
      case 2:
        return 'Packed';
      case 3:
        return 'Shipped';
      case 4:
        return 'Delivered';
      case 5:
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }

  bool get isOngoing => status >= 0 && status <= 3;
  bool get isCompleted => status == 4;
  bool get isCancelled => status == 5;
}
