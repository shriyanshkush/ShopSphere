class BestSellingProductModel {
  final String id;
  final String name;
  final String category;
  final int soldCount;
  final double price;
  final String? image;

  const BestSellingProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.soldCount,
    required this.price,
    required this.image,
  });

  factory BestSellingProductModel.fromJson(Map<String, dynamic> json) {
    final images = (json['images'] as List?) ?? const [];
    return BestSellingProductModel(
      id: (json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      soldCount: (json['soldCount'] ?? 0) as int,
      price: ((json['price'] ?? 0) as num).toDouble(),
      image: images.isNotEmpty ? images.first.toString() : null,
    );
  }
}

class InventoryAlertModel {
  final String id;
  final String name;
  final String? sku;
  final int quantity;
  final String? image;

  const InventoryAlertModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.quantity,
    required this.image,
  });

  factory InventoryAlertModel.fromJson(Map<String, dynamic> json) {
    final images = (json['images'] as List?) ?? const [];
    return InventoryAlertModel(
      id: (json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      sku: json['sku']?.toString(),
      quantity: (json['quantity'] ?? 0) as int,
      image: images.isNotEmpty ? images.first.toString() : null,
    );
  }
}

class AdminDashboardModel {
  final int totalOrders;
  final int totalUsers;
  final double totalRevenue;
  final List<BestSellingProductModel> topProducts;
  final List<InventoryAlertModel> lowStockProducts;

  const AdminDashboardModel({
    required this.totalOrders,
    required this.totalUsers,
    required this.totalRevenue,
    required this.topProducts,
    required this.lowStockProducts,
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    return AdminDashboardModel(
      totalOrders: json['overview']['totalOrders'] ?? 0,
      totalUsers: json['overview']['totalUsers'] ?? 0,
      totalRevenue: ((json['overview']['totalEarnings'] ?? 0) as num).toDouble(),
      topProducts: ((json['topProducts'] as List?) ?? const [])
          .map((item) => BestSellingProductModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      lowStockProducts: ((json['lowStockProducts'] as List?) ?? const [])
          .map((item) => InventoryAlertModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
