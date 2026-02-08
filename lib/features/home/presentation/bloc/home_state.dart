import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';

const _unset = Object();

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
  final String lastQuery;

  final double? minPrice;
  final double? maxPrice;
  final double minRating;
  final String sort;

  final String searchQuery;
  final bool isSearching;


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
    required this.lastQuery,
    required this.minPrice,
    required this.maxPrice,
    required this.minRating,
    required this.sort,
    required this.searchQuery,
    required this.isSearching,
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
      lastQuery: '',
      minPrice: null,
      maxPrice: null,
      minRating: 0,
      sort: '',
      searchQuery: '',
      isSearching: false,
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
    String? lastQuery,
    Object? minPrice = _unset,
    Object? maxPrice = _unset,
    double? minRating,
    String? sort,
    String? searchQuery,
    bool? isSearching,
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
      lastQuery: lastQuery ?? this.lastQuery,
      minPrice: minPrice == _unset ? this.minPrice : minPrice as double?,
      maxPrice: maxPrice == _unset ? this.maxPrice : maxPrice as double?,
      minRating: minRating ?? this.minRating,
      sort: sort ?? this.sort,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
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
        lastQuery,
        minPrice,
        maxPrice,
        minRating,
        sort,
    searchQuery,
    isSearching,
      ];
}
