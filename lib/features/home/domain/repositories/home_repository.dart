import '../../data/models/product_model.dart';

abstract class HomeRepository {
  /// Home curated products
  Future<List<ProductModel>> getHomeProducts();

  /// Search
  Future<List<ProductModel>> searchProducts(String query);

  /// Suggestions
  Future<List<String>> getSearchSuggestions(String query);

  /// Filters
  Future<List<ProductModel>> getFilteredProducts({
    required double minPrice,
    required double maxPrice,
    required double minRating,
    required Set<String> brands,
  });

  /// Wishlist
  Future<void> toggleWishlist(String productId, bool add);

  Future<Set<String>> getWishlist();
}
