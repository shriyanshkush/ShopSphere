import 'package:shopsphere/features/home/data/datasources/%20home_remote_data_source.dart';

import '../../domain/repositories/home_repository.dart';
import '../models/product_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remote;

  HomeRepositoryImpl(this.remote);

  /// HOME
  @override
  Future<List<ProductModel>> getHomeProducts() async {
    final response = await remote.fetchHome();
    return response.products;
  }

  /// SEARCH
  @override
  Future<List<ProductModel>> searchProducts(String query) {
    return remote.searchProducts(query);
  }

  /// SUGGESTIONS
  @override
  Future<List<String>> getSearchSuggestions(String query) {
    return remote.getSearchSuggestions(query);
  }

  /// FILTERS
  @override
  Future<List<ProductModel>> getFilteredProducts({
    required double minPrice,
    required double maxPrice,
    required double minRating,
    required Set<String> brands,
  }) {
    return remote.getFilteredProducts(
      minPrice: minPrice,
      maxPrice: maxPrice,
      minRating: minRating,
      brands: brands,
    );
  }

  /// WISHLIST
  @override
  Future<void> toggleWishlist(String productId, bool add) {
    return remote.toggleWishlist(productId, add);
  }

  @override
  Future<Set<String>> getWishlist() {
    return remote.fetchWishlist();
  }

}
