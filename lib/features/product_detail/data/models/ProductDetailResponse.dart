import 'package:shopsphere/features/product_detail/data/models/product_detail_model.dart';
import 'package:shopsphere/features/product_detail/data/models/review_model.dart';

class ProductDetailResponse {
  final ProductDetailModel product;
  final List<ReviewModel> reviews;

  ProductDetailResponse({
    required this.product,
    required this.reviews,
  });

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailResponse(
      product: ProductDetailModel.fromJson(json['product']),
      reviews: (json['reviews'] as List)
          .map((e) => ReviewModel.fromJson(e))
          .toList(),
    );
  }
}
