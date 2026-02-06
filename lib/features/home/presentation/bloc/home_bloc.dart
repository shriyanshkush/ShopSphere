import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../domain/repositories/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repo;

  HomeBloc(this.repo) : super(HomeState.initial()) {
    on<LoadHome>(_loadHome);
    on<LoadCategories>(_loadCategories);
    on<LoadCategoryProducts>(_loadCategoryProducts);
    on<SearchQueryChanged>(_searchSuggestions);
    on<SearchSubmitted>(_searchProducts);
    on<ApplyFilters>(_applyFilters);
    on<ToggleWishlist>(_toggleWishlist);
    on<AddToCart>(_addToCart);
    on<LoadCart>(_loadCart);
    on<LoadWishlistProducts>(_loadWishlistProducts);
  }

  Future<void> _loadHome(LoadHome event, Emitter<HomeState> emit) async {
    emit(state.copyWith(loading: true));
    final products = await repo.getHomeProducts();
    final wishlist = await repo.getWishlist();
    final categories = await repo.getCategories();
    final cart = await repo.getCart();
    final cartItems = (cart['items'] as List? ?? []);
    emit(state.copyWith(
      loading: false,
      products: products,
      wishlist: wishlist,
      categories: categories,
      cartItems: cartItems,
      cartCount: cartItems.fold<int>(0, (s, e) => s + ((e['quantity'] as num?)?.toInt() ?? 0)),
      cartTotal: (cart['totalAmount'] as num?)?.toDouble() ?? 0,
    ));
  }

  Future<void> _loadCategories(LoadCategories event, Emitter<HomeState> emit) async {
    final categories = await repo.getCategories();
    emit(state.copyWith(categories: categories));
  }

  Future<void> _loadCategoryProducts(LoadCategoryProducts event, Emitter<HomeState> emit) async {
    emit(state.copyWith(loading: true, selectedCategory: event.category));
    final products = await repo.getProductsByCategory(event.category);
    emit(state.copyWith(loading: false, products: products));
  }

  Future<void> _searchSuggestions(SearchQueryChanged event, Emitter<HomeState> emit) async {
    if (event.query.trim().isEmpty) {
      emit(state.copyWith(suggestions: []));
      return;
    }
    if (event.query.length < 2) {
      emit(state.copyWith(suggestions: []));
      return;
    }
    final suggestions = await repo.getSearchSuggestions(event.query);
    emit(state.copyWith(suggestions: suggestions));
  }

  Future<void> _searchProducts(SearchSubmitted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(loading: true));
    final products = await repo.searchProducts(
      event.query,
      category: state.selectedCategory.isEmpty ? null : state.selectedCategory,
      minPrice: state.minPrice,
      maxPrice: state.maxPrice,
      sort: state.sort.isEmpty ? null : state.sort,
    );
    emit(state.copyWith(loading: false, products: products, suggestions: []));
  }

  Future<void> _applyFilters(ApplyFilters event, Emitter<HomeState> emit) async {
    final nextCategory = event.category ?? state.selectedCategory;
    final nextMin = event.minPrice ?? state.minPrice;
    final nextMax = event.maxPrice ?? state.maxPrice;
    final nextRating = event.minRating ?? state.minRating;
    final nextSort = event.sort ?? state.sort;

    emit(state.copyWith(
      loading: true,
      selectedCategory: nextCategory,
      minPrice: nextMin,
      maxPrice: nextMax,
      minRating: nextRating,
      sort: nextSort,
    ));

    final products = await repo.getFilteredProducts(
      category: nextCategory.isEmpty ? null : nextCategory,
      minPrice: nextMin,
      maxPrice: nextMax,
      minRating: nextRating,
      sort: nextSort.isEmpty ? null : nextSort,
    );

    emit(state.copyWith(loading: false, products: products));
  }

  Future<void> _toggleWishlist(ToggleWishlist event, Emitter<HomeState> emit) async {
    final isWishlisted = state.wishlist.contains(event.productId);
    final updated = Set<String>.from(state.wishlist);
    if (isWishlisted) {
      updated.remove(event.productId);
    } else {
      updated.add(event.productId);
    }
    emit(state.copyWith(wishlist: updated));
    try {
      await repo.toggleWishlist(event.productId, !isWishlisted);
      add(LoadWishlistProducts());
    } catch (_) {
      emit(state.copyWith(wishlist: state.wishlist));
    }
  }

  Future<void> _addToCart(AddToCart event, Emitter<HomeState> emit) async {
    await repo.addToCart(event.productId);
    add(LoadCart());
  }

  Future<void> _loadCart(LoadCart event, Emitter<HomeState> emit) async {
    final cart = await repo.getCart();
    final items = (cart['items'] as List? ?? []);
    emit(state.copyWith(
      cartItems: items,
      cartCount: items.fold<int>(0, (s, e) => s + ((e['quantity'] as num?)?.toInt() ?? 0)),
      cartTotal: (cart['totalAmount'] as num?)?.toDouble() ?? 0,
    ));
  }

  Future<void> _loadWishlistProducts(LoadWishlistProducts event, Emitter<HomeState> emit) async {
    final items = await repo.getWishlistProducts();
    emit(state.copyWith(wishlistProducts: items));
  }
}
