import 'package:shopsphere/features/home/data/datasources/%20home_remote_data_source.dart';
import '../../domain/repositories/home_repository.dart';
import '../models/product_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remote;

  HomeRepositoryImpl(this.remote);

  @override
  Future<List<ProductModel>> getHomeProducts() async {
    final response = await remote.fetchHome();
    return response.products;
  }

  @override
  Future<List<ProductModel>> searchProducts(
    String query, {
    String? category,
    double? minPrice,
    double? maxPrice,
    String? sort,
  }) {
    return remote.searchProducts(
      query,
      category: category,
      minPrice: minPrice,
      maxPrice: maxPrice,
      sort: sort,
    );
  }

  @override
  Future<List<String>> getSearchSuggestions(String query) {
    return remote.getSearchSuggestions(query);
  }

  @override
  Future<List<ProductModel>> getFilteredProducts({
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? category,
    String? sort,
  }) {
    return remote.getFilteredProducts(
      minPrice: minPrice,
      maxPrice: maxPrice,
      minRating: minRating,
      category: category,
      sort: sort,
    );
  }

  @override
  Future<List<String>> getCategories() => remote.getCategories();

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) => remote.getProductsByCategory(category);

  @override
  Future<void> toggleWishlist(String productId, bool add) {
    return remote.toggleWishlist(productId, add);
  }

  @override
  Future<Set<String>> getWishlist() {
    return remote.fetchWishlist();
  }

  @override
  Future<List<ProductModel>> getWishlistProducts() => remote.fetchWishlistProducts();

  @override
  Future<void> addToCart(String productId) => remote.addToCart(productId);

  @override
  Future<void> removeFromCart(String productId) => remote.removeFromCart(productId);

  @override
  Future<Map<String, dynamic>> getCart() => remote.getCart();
}
