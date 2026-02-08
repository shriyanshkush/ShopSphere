class RecentOrderModel {
  final String id;
  final String productId;
  final String title;
  final String status;
  final String image;
  final bool canTrack;
  final bool canReview;

  const RecentOrderModel({
    required this.id,
    required this.productId,
    required this.title,
    required this.status,
    required this.image,
    this.canTrack = false,
    this.canReview = false,
  });

  factory RecentOrderModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('products')) {
      final products = (json['products'] as List? ?? []);
      final firstItem = products.isNotEmpty ? products.first as Map<String, dynamic> : {};
      final product = (firstItem['product'] as Map<String, dynamic>? ?? {});
      final images = (product['images'] as List? ?? []);
      final statusCode = (json['status'] as num?)?.toInt() ?? 0;
      final statusMap = {
        0: 'Pending',
        1: 'Confirmed',
        2: 'Packed',
        3: 'Shipped',
        4: 'Delivered',
        5: 'Cancelled',
      };
      return RecentOrderModel(
        id: json['_id']?.toString() ?? '',
        productId: product['_id']?.toString() ?? '',
        title: product['name']?.toString() ?? 'Order item',
        status: statusMap[statusCode] ?? 'Pending',
        image: images.isNotEmpty ? images.first.toString() : '',
        canTrack: statusCode > 0 && statusCode < 4,
        canReview: statusCode == 4,
      );
    }
    return RecentOrderModel(
      id: json['_id']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      canTrack: json['canTrack'] == true,
      canReview: json['canReview'] == true,
    );
  }
}
