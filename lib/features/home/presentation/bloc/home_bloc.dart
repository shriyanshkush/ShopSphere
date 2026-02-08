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
    on<RemoveFromCart>(_removeFromCart);
    on<LoadCart>(_loadCart);
    on<LoadWishlistProducts>(_loadWishlistProducts);
    on<ClearSearch>(_clearSearch);

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

  Future<void> _searchSuggestions(
      SearchQueryChanged event,
      Emitter<HomeState> emit,
      ) async {
    final query = event.query.trim();

    emit(state.copyWith(
      searchQuery: query,
      isSearching: query.isNotEmpty,
    ));

    // ❌ cleared search
    if (query.isEmpty) {
      final products = await repo.getHomeProducts();
      emit(state.copyWith(
        products: products,
        suggestions: [],
        isSearching: false,
      ));
      return;
    }

    // optional: fetch suggestions
    if (query.length >= 2) {
      final suggestions = await repo.getSearchSuggestions(query);
      emit(state.copyWith(suggestions: suggestions));
    }

    // 🔍 LIVE SEARCH
    final products = await repo.searchProducts(
      query,
      category: state.selectedCategory.isEmpty ? null : state.selectedCategory,
      minPrice: state.minPrice,
      maxPrice: state.maxPrice,
      sort: state.sort.isEmpty ? null : state.sort,
    );

    emit(state.copyWith(products: products));
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
    final nextCategory = event.clear ? '' : event.category;
    final nextMin = event.clear ? null : event.minPrice;
    final nextMax = event.clear ? null : event.maxPrice;
    final nextRating = event.clear ? 0.0 : (event.minRating ?? state.minRating);
    final nextSort = event.clear ? '' : event.sort;

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

  Future<void> _removeFromCart(RemoveFromCart event, Emitter<HomeState> emit) async {
    await repo.removeFromCart(event.productId);
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

  Future<void> _clearSearch(
      ClearSearch event,
      Emitter<HomeState> emit,
      ) async {
    final products = await repo.getHomeProducts();
    emit(state.copyWith(
      searchQuery: '',
      products: products,
      suggestions: [],
      isSearching: false,
    ));
  }

}
