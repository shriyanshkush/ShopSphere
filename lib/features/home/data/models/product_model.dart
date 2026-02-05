class ProductModel {
  final String id;
  final String name;
  final double price;
  final double rating;
  final int reviews;
  final List<String> images;
  final String badge;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.images,
    required this.badge,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      reviews: json['reviews'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
      badge: json['badge'] ?? '',
    );
  }
}
