import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadHome extends HomeEvent {}
class LoadCategories extends HomeEvent {}
class LoadCategoryProducts extends HomeEvent {
  final String category;
  LoadCategoryProducts(this.category);
}

class SearchQueryChanged extends HomeEvent {
  final String query;
  SearchQueryChanged(this.query);
}

class SearchSubmitted extends HomeEvent {
  final String query;
  SearchSubmitted(this.query);
}

class ApplyFilters extends HomeEvent {
  final String category;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final String sort;
  final bool clear;

  ApplyFilters({
    this.category = '',
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.sort = '',
    this.clear = false,
  });
}

class ToggleWishlist extends HomeEvent {
  final String productId;
  ToggleWishlist(this.productId);
}

class AddToCart extends HomeEvent {
  final String productId;
  AddToCart(this.productId);
}

class RemoveFromCart extends HomeEvent {
  final String productId;
  RemoveFromCart(this.productId);
}

class LoadCart extends HomeEvent {}
class LoadWishlistProducts extends HomeEvent {}
