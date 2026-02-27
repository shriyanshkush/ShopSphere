import 'package:shopsphere/features/product_detail/data/models/ProductDetailResponse.dart';

import '../../domain/repositories/product_detail_repository.dart';
import '../datasources/product_detail_remote_data_source.dart';
import '../models/product_detail_model.dart';
import '../models/review_model.dart';

class ProductDetailRepositoryImpl implements ProductDetailRepository {
  final ProductDetailRemoteDataSource remote;

  ProductDetailRepositoryImpl(this.remote);

  @override
  Future<ProductDetailResponse> getProductDetail(String id) {
    return remote.getProductDetail(id);
  }

  @override
  Future<List<ReviewModel>> getReviews(String productId) {
    return remote.getReviews(productId);
  }

  @override
  Future<void> toggleWishlist(String productId,bool add) {
    return remote.toggleWishlist(productId,add);
  }

  @override
  Future<void> addToCart(String productId) {
    return remote.addToCart(productId);
  }

  @override
  Future<void> addReview({
    required String productId,
    required int rating,
    required String comment,
  }) {
    return remote.addReview(
      productId: productId,
      rating: rating,
      comment: comment,
    );
  }

  @override
  Future<Set<String>> getWishlist() {
    return remote.fetchWishlist();
  }

}
