class AdminOrderItemModel {
  final String name;
  final int quantity;
  final double unitPrice;

  const AdminOrderItemModel({
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  double get total => quantity * unitPrice;

  factory AdminOrderItemModel.fromJson(Map<String, dynamic> json) {
    final product = (json['product'] as Map<String, dynamic>?) ?? {};
    return AdminOrderItemModel(
      name: (product['name'] ?? 'Unknown Product').toString(),
      quantity: (json['quantity'] ?? 0) as int,
      unitPrice: ((product['price'] ?? 0) as num).toDouble(),
    );
  }
}

class AdminOrderModel {
  final String id;
  final int statusCode;
  final String status;
  final double amount;
  final DateTime? orderedAt;
  final List<AdminOrderItemModel> items;

  const AdminOrderModel({
    required this.id,
    required this.statusCode,
    required this.status,
    required this.amount,
    required this.orderedAt,
    required this.items,
  });

  factory AdminOrderModel.fromJson(Map<String, dynamic> json) {
    final statusCode = (json['status'] ?? 0) as int;
    final orderedAtTimestamp = json['orderedAt'];

    return AdminOrderModel(
      id: (json['_id'] ?? '').toString(),
      statusCode: statusCode,
      status: _statusFromCode(statusCode),
      amount: ((json['totalPrice'] ?? 0) as num).toDouble(),
      orderedAt: orderedAtTimestamp is num
          ? DateTime.fromMillisecondsSinceEpoch(orderedAtTimestamp.toInt())
          : null,
      items: ((json['products'] as List?) ?? const [])
          .map((item) => AdminOrderItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  static String _statusFromCode(int code) {
    switch (code) {
      case 0:
        return 'Pending';
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
        return 'Unknown';
    }
  }
}
