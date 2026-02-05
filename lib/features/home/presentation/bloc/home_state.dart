import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';

class HomeState extends Equatable {
  final bool loading;
  final List<ProductModel> products;
  final List<String> suggestions;
  final Set<String> wishlist;
  final int cartCount;

  final double minPrice;
  final double maxPrice;
  final double minRating;
  final Set<String> brands;

  const HomeState({
    required this.loading,
    required this.products,
    required this.suggestions,
    required this.wishlist,
    required this.cartCount,
    required this.minPrice,
    required this.maxPrice,
    required this.minRating,
    required this.brands,
  });

  factory HomeState.initial() {
    return const HomeState(
      loading: false,
      products: [],
      suggestions: [],
      wishlist: {},
      cartCount: 0,
      minPrice: 0,
      maxPrice: 2000,
      minRating: 0,
      brands: {},
    );
  }

  HomeState copyWith({
    bool? loading,
    List<ProductModel>? products,
    List<String>? suggestions,
    Set<String>? wishlist,
    int? cartCount,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    Set<String>? brands,
  }) {
    return HomeState(
      loading: loading ?? this.loading,
      products: products ?? this.products,
      suggestions: suggestions ?? this.suggestions,
      wishlist: wishlist ?? this.wishlist,
      cartCount: cartCount ?? this.cartCount,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      brands: brands ?? this.brands,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    products,
    suggestions,
    wishlist,
    cartCount,
    minPrice,
    maxPrice,
    minRating,
    brands,
  ];
}
