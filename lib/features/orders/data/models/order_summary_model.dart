class OrderSummaryModel {
  final String id;
  final String orderCode;
  final DateTime orderedAt;
  final int itemCount;
  final int status;
  final String statusLabel;
  final String statusDescription;
  final String firstItemName;
  final String firstItemSubtitle;
  final String firstItemImage;
  final double firstItemPrice;

  const OrderSummaryModel({
    required this.id,
    required this.orderCode,
    required this.orderedAt,
    required this.itemCount,
    required this.status,
    required this.statusLabel,
    required this.statusDescription,
    required this.firstItemName,
    required this.firstItemSubtitle,
    required this.firstItemImage,
    required this.firstItemPrice,
  });

  factory OrderSummaryModel.fromJson(Map<String, dynamic> json) {
    final products = (json['products'] as List? ?? []);
    final first = products.isNotEmpty ? (products.first as Map<String, dynamic>) : <String, dynamic>{};
    final product = (first['product'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};

    return OrderSummaryModel(
      id: (json['_id'] ?? '').toString(),
      orderCode: _orderCodeFromId((json['_id'] ?? '').toString()),
      orderedAt: DateTime.fromMillisecondsSinceEpoch((json['orderedAt'] as num?)?.toInt() ?? 0),
      itemCount: products.fold<int>(0, (sum, p) => sum + (((p as Map)['quantity'] as num?)?.toInt() ?? 0)),
      status: (json['status'] as num?)?.toInt() ?? 0,
      statusLabel: _statusLabel((json['status'] as num?)?.toInt() ?? 0),
      statusDescription: _statusDescription((json['status'] as num?)?.toInt() ?? 0),
      firstItemName: (product['name'] ?? 'Order item').toString(),
      firstItemSubtitle: [
        if ((product['category'] ?? '').toString().isNotEmpty) (product['category']).toString(),
        if ((product['description'] ?? '').toString().isNotEmpty) (product['description']).toString(),
      ].join(' • '),
      firstItemImage: ((product['images'] as List?)?.firstOrNull ?? '').toString(),
      firstItemPrice: ((product['price'] as num?)?.toDouble() ?? 0),
    );
  }

  static String _orderCodeFromId(String id) {
    if (id.isEmpty) return '#ORD-000000';
    final suffix = id.length >= 7 ? id.substring(id.length - 7).toUpperCase() : id.toUpperCase();
    return '#ORD-$suffix';
  }

  static String _statusLabel(int status) {
    switch (status) {
      case 1:
      case 2:
        return 'Processing';
      case 3:
        return 'On the Way';
      case 4:
        return 'Delivered';
      case 5:
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }

  static String _statusDescription(int status) {
    switch (status) {
      case 1:
      case 2:
        return 'Preparing shipment';
      case 3:
        return 'In transit';
      case 4:
        return 'Completed';
      case 5:
        return 'Order cancelled';
      default:
        return 'Awaiting confirmation';
    }
  }
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
