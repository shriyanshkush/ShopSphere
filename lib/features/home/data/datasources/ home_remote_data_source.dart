import 'package:dio/dio.dart';
import 'package:shopsphere/core/services/api_service.dart';
import '../models/home_response.dart';
import '../models/product_model.dart';

class HomeRemoteDataSource {
  final Dio dio = ApiService().dio;

  Future<HomeResponse> fetchHome() async {
    final res = await dio.get('/home');
    return HomeResponse.fromJson(res.data);
  }

  Future<List<ProductModel>> searchProducts(
    String query, {
    String? category,
    double? minPrice,
    double? maxPrice,
    String? sort,
  }) async {
    final q = query.trim();
    if (q.isEmpty) {
      return getFilteredProducts(
        minPrice: minPrice,
        maxPrice: maxPrice,
        category: category,
        sort: sort,
      );
    }

    final res = await dio.get(
      '/api/products/search/$q',
      queryParameters: {
        if (category != null && category.isNotEmpty) 'category': category,
        if (minPrice != null) 'minPrice': minPrice,
        if (maxPrice != null) 'maxPrice': maxPrice,
        if (sort != null && sort.isNotEmpty) 'sort': sort,
      },
    );
    return (res.data['products'] as List)
        .map((e) => ProductModel.fromJson(e))
        .toList();
  }

  Future<List<String>> getSearchSuggestions(String query) async {
    final res = await dio.get('/api/products/suggestions', queryParameters: {'query': query});
    return (res.data['suggestions'] as List)
        .map((e) => e['name'].toString())
        .toList();
  }

  Future<List<ProductModel>> getFilteredProducts({
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? category,
    String? sort,
  }) async {
    final res = await dio.get(
      '/api/products',
      queryParameters: {
        if (minPrice != null) 'minPrice': minPrice,
        if (maxPrice != null) 'maxPrice': maxPrice,
        if (minRating != null) 'minRating': minRating,
        if (category != null && category.isNotEmpty) 'category': category,
        if (sort != null && sort.isNotEmpty) 'sort': sort,
      },
    );

    return (res.data['products'] as List)
        .map((e) => ProductModel.fromJson(e))
        .toList();
  }

  Future<List<String>> getCategories() async {
    final res = await dio.get('/api/products/categories');
    return ((res.data['categories'] as List?) ?? []).map((e) => e.toString()).toList();
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final res = await dio.get('/api/products/category/$category');
    return (res.data['products'] as List)
        .map((e) => ProductModel.fromJson(e))
        .toList();
  }

  Future<void> toggleWishlist(String productId, bool add) async {
    if (add) {
      await dio.post('/api/wishlist/add', data: {'productId': productId});
    } else {
      await dio.delete('/api/wishlist/remove/$productId');
    }
  }

  Future<List<ProductModel>> fetchWishlistProducts() async {
    final res = await dio.get('/api/wishlist');
    final products = (res.data['products'] as List? ?? []);
    return products
        .map((p) => ProductModel.fromJson(p['productId'] as Map<String, dynamic>))
        .toList();
  }

  Future<Set<String>> fetchWishlist() async {
    final res = await dio.get('/api/wishlist');
    final products = (res.data['products'] as List? ?? []);
    return products.map((p) => p['productId']['_id'].toString()).toSet();
  }

  Future<void> addToCart(String productId) async {
    await dio.post('/api/add-to-cart', data: {'id': productId});
  }

  Future<void> removeFromCart(String productId) async {
    await dio.delete('/api/remove-from-cart/$productId');
  }

  Future<Map<String, dynamic>> getCart() async {
    final res = await dio.get('/api/cart');
    return res.data;
  }
}
