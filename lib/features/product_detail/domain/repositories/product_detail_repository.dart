import 'package:shopsphere/features/product_detail/data/models/ProductDetailResponse.dart';

import '../../data/models/product_detail_model.dart';
import '../../data/models/review_model.dart';

abstract class ProductDetailRepository {
  Future<ProductDetailResponse> getProductDetail(String id);
  Future<List<ReviewModel>> getReviews(String productId);
  Future<void> toggleWishlist(String productId);
  Future<void> addToCart(String productId);
  Future<void> addReview({
    required String productId,
    required int rating,
    required String comment,
  });

}
