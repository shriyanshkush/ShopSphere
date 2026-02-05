import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';

class HomeState extends Equatable {
  final bool loading;
  final List<ProductModel> products;
  final List<String> suggestions;
  final Set<String> wishlist;
  final List<ProductModel> wishlistProducts;
  final int cartCount;
  final List<dynamic> cartItems;
  final double cartTotal;

  final List<String> categories;
  final String selectedCategory;

  final double minPrice;
  final double maxPrice;
  final double minRating;
  final String sort;

  const HomeState({
    required this.loading,
    required this.products,
    required this.suggestions,
    required this.wishlist,
    required this.wishlistProducts,
    required this.cartCount,
    required this.cartItems,
    required this.cartTotal,
    required this.categories,
    required this.selectedCategory,
    required this.minPrice,
    required this.maxPrice,
    required this.minRating,
    required this.sort,
  });

  factory HomeState.initial() {
    return const HomeState(
      loading: false,
      products: [],
      suggestions: [],
      wishlist: {},
      wishlistProducts: [],
      cartCount: 0,
      cartItems: [],
      cartTotal: 0,
      categories: [],
      selectedCategory: '',
      minPrice: 120,
      maxPrice: 850,
      minRating: 0,
      sort: '',
    );
  }

  HomeState copyWith({
    bool? loading,
    List<ProductModel>? products,
    List<String>? suggestions,
    Set<String>? wishlist,
    List<ProductModel>? wishlistProducts,
    int? cartCount,
    List<dynamic>? cartItems,
    double? cartTotal,
    List<String>? categories,
    String? selectedCategory,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sort,
  }) {
    return HomeState(
      loading: loading ?? this.loading,
      products: products ?? this.products,
      suggestions: suggestions ?? this.suggestions,
      wishlist: wishlist ?? this.wishlist,
      wishlistProducts: wishlistProducts ?? this.wishlistProducts,
      cartCount: cartCount ?? this.cartCount,
      cartItems: cartItems ?? this.cartItems,
      cartTotal: cartTotal ?? this.cartTotal,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        products,
        suggestions,
        wishlist,
        wishlistProducts,
        cartCount,
        cartItems,
        cartTotal,
        categories,
        selectedCategory,
        minPrice,
        maxPrice,
        minRating,
        sort,
      ];
}
