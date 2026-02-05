class ProductDetailModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final int reviews;
  final List<String> images;
  final bool inStock;

  ProductDetailModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.images,
    required this.inStock,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      rating: (json['averageRating'] as num).toDouble(),
      reviews: json['totalReviews'],
      images: List<String>.from(json['images']),
      inStock: json['quantity'] > 0,
    );
  }
}
