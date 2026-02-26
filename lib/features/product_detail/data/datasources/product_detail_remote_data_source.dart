import 'package:dio/dio.dart';
import 'package:shopsphere/features/product_detail/data/models/ProductDetailResponse.dart';
import '../../../../core/services/api_service.dart';
import '../models/product_detail_model.dart';
import '../models/review_model.dart';

class ProductDetailRemoteDataSource {
  final Dio dio = ApiService().dio;

  Future<ProductDetailResponse> getProductDetail(String id) async {
    final res = await dio.get('/api/products/$id/detail');
    return ProductDetailResponse.fromJson(res.data);
  }


  Future<List<ReviewModel>> getReviews(String productId) async {
    final res = await dio.get('/api/reviews/$productId');
    return (res.data['reviews'] as List)
        .map((e) => ReviewModel.fromJson(e))
        .toList();
  }

  Future<void> toggleWishlist(String productId) async {
    try {
      await dio.post('/api/wishlist/add', data: {'productId': productId});
    } on DioException catch (e) {
      final alreadyInWishlist = e.response?.statusCode == 400 &&
          (e.response?.data is Map) &&
          (e.response?.data['msg']
                  ?.toString()
                  .toLowerCase()
                  .contains('already in wishlist') ??
              false);

      if (alreadyInWishlist) {
        await dio.delete('/api/wishlist/remove/$productId');
        return;
      }
      rethrow;
    }
  }

  Future<void> addToCart(String productId) async {
    await dio.post('/api/add-to-cart', data: { 'id': productId });
  }

  Future<void> addReview({
    required String productId,
    required int rating,
    required String comment,
  }) async {
    await dio.post('/api/reviews', data: {
      'productId': productId,
      'rating': rating,
      'comment': comment,
    });
  }

}
