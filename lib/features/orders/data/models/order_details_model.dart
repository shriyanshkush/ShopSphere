class OrderDetailsModel {
  final String id;
  final String orderCode;
  final int status;
  final String statusLabel;
  final DateTime orderedAt;
  final List<OrderLineItemModel> items;
  final String address;
  final String paymentMethod;
  final String paymentStatus;
  final double subtotal;
  final double tax;
  final double shippingFee;
  final double total;

  const OrderDetailsModel({
    required this.id,
    required this.orderCode,
    required this.status,
    required this.statusLabel,
    required this.orderedAt,
    required this.items,
    required this.address,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.subtotal,
    required this.tax,
    required this.shippingFee,
    required this.total,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    final products = (json['products'] as List? ?? []);
    final items = products
        .map((e) => OrderLineItemModel.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
    final total = (json['totalPrice'] as num?)?.toDouble() ?? 0;
    final subtotal = items.fold<double>(0, (sum, item) => sum + (item.price * item.quantity));
    final tax = subtotal > 0 ? subtotal * 0.08 : 0;
    final shipping = (total - subtotal - tax).clamp(0, double.infinity);

    return OrderDetailsModel(
      id: (json['_id'] ?? '').toString(),
      orderCode: _orderCodeFromId((json['_id'] ?? '').toString()),
      status: (json['status'] as num?)?.toInt() ?? 0,
      statusLabel: _statusLabel((json['status'] as num?)?.toInt() ?? 0),
      orderedAt: DateTime.fromMillisecondsSinceEpoch((json['orderedAt'] as num?)?.toInt() ?? 0),
      items: items,
      address: (json['address'] ?? 'Address unavailable').toString(),
      paymentMethod: (json['payment']?['method'] ?? 'COD').toString(),
      paymentStatus: (json['payment']?['status'] ?? 'pending').toString(),
      subtotal: subtotal,
      tax: tax.toDouble(),
      shippingFee: shipping.toDouble(),
      total: total,
    );
  }

  static String _orderCodeFromId(String id) {
    if (id.isEmpty) return '#ORD-000000';
    final suffix = id.length >= 8 ? id.substring(id.length - 8).toUpperCase() : id.toUpperCase();
    return '#ORD-$suffix';
  }

  static String _statusLabel(int status) {
    switch (status) {
      case 1:
      case 2:
        return 'Processing';
      case 3:
        return 'In Transit';
      case 4:
        return 'Delivered';
      case 5:
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }
}

class OrderLineItemModel {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final double price;
  final int quantity;

  const OrderLineItemModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.price,
    required this.quantity,
  });

  factory OrderLineItemModel.fromJson(Map<String, dynamic> json) {
    final product = (json['product'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
    return OrderLineItemModel(
      id: (product['_id'] ?? '').toString(),
      title: (product['name'] ?? 'Order item').toString(),
      subtitle: [
        if ((product['category'] ?? '').toString().isNotEmpty) (product['category']).toString(),
        if ((product['description'] ?? '').toString().isNotEmpty) (product['description']).toString(),
      ].join(' • '),
      image: ((product['images'] as List?)?.firstOrNull ?? '').toString(),
      price: (product['price'] as num?)?.toDouble() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    );
  }
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
