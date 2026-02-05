import 'package:dio/dio.dart';
import 'package:shopsphere/core/services/api_service.dart';
import '../models/home_response.dart';
import '../models/product_model.dart';

class HomeRemoteDataSource {
  final Dio dio = ApiService().dio;

  /// HOME
  Future<HomeResponse> fetchHome() async {
    final res = await dio.get('/home');
    return HomeResponse.fromJson(res.data);
  }

  /// SEARCH PRODUCTS
  Future<List<ProductModel>> searchProducts(String query) async {
    final res = await dio.get('/api/products/search/$query');
    return (res.data['products'] as List)
        .map((e) => ProductModel.fromJson(e))
        .toList();
  }

  /// SEARCH SUGGESTIONS
  Future<List<String>> getSearchSuggestions(String query) async {
    final res =
    await dio.get('/api/products/suggestions', queryParameters: {
      'query': query,
    });

    return (res.data['suggestions'] as List)
        .map((e) => e['name'].toString())
        .toList();
  }

  /// FILTER PRODUCTS
  Future<List<ProductModel>> getFilteredProducts({
    required double minPrice,
    required double maxPrice,
    required double minRating,
    required Set<String> brands,
  }) async {
    final res = await dio.get(
      '/api/products',
      queryParameters: {
        'minPrice': minPrice,
        'maxPrice': maxPrice,
        'minRating': minRating,
        if (brands.isNotEmpty) 'category': brands.first,
      },
    );

    return (res.data['products'] as List)
        .map((e) => ProductModel.fromJson(e))
        .toList();
  }

  /// WISHLIST TOGGLE
  Future<void> toggleWishlist(String productId, bool add) async {
    if (add) {
      await dio.post('/api/wishlist/add', data: {
        'productId': productId,
      });
    } else {
      await dio.delete('/api/wishlist/remove/$productId');
    }
  }

  /// GET WISHLIST
  Future<Set<String>> fetchWishlist() async {
    final res = await dio.get('/api/wishlist');

    final products = res.data['products'] as List;
    return products
        .map((p) => p['productId']['_id'].toString())
        .toSet();
  }

}
