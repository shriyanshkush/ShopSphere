import '../../../profile/data/models/user_model.dart';
import '../../data/models/product_model.dart';

abstract class HomeRepository {
  Future<List<ProductModel>> getHomeProducts();

  Future<List<ProductModel>> searchProducts(
    String query, {
    String? category,
    double? minPrice,
    double? maxPrice,
    String? sort,
  });

  Future<List<String>> getSearchSuggestions(String query);

  Future<List<ProductModel>> getFilteredProducts({
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? category,
    String? sort,
  });

  Future<List<String>> getCategories();
  Future<List<ProductModel>> getProductsByCategory(String category);

  Future<void> toggleWishlist(String productId, bool add);
  Future<Set<String>> getWishlist();
  Future<List<ProductModel>> getWishlistProducts();

  Future<void> addToCart(String productId);
  Future<void> removeFromCart(String productId);
  Future<Map<String, dynamic>> getCart();

  Future<UserModel?> getUser();
}
