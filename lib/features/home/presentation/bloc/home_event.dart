import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial load
class LoadHome extends HomeEvent {}

/// Search
class SearchQueryChanged extends HomeEvent {
  final String query;
  SearchQueryChanged(this.query);
}

class SearchSubmitted extends HomeEvent {
  final String query;
  SearchSubmitted(this.query);
}

/// Filters
class ApplyFilters extends HomeEvent {
  final double minPrice;
  final double maxPrice;
  final double minRating;
  final Set<String> brands;

  ApplyFilters({
    required this.minPrice,
    required this.maxPrice,
    required this.minRating,
    required this.brands,
  });
}

/// Wishlist
class ToggleWishlist extends HomeEvent {
  final String productId;
  ToggleWishlist(this.productId);
}

/// Cart
class AddToCart extends HomeEvent {}
