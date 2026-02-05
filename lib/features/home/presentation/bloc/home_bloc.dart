import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../domain/repositories/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repo;

  HomeBloc(this.repo) : super(HomeState.initial()) {
    on<LoadHome>(_loadHome);
    on<SearchQueryChanged>(_searchSuggestions);
    on<SearchSubmitted>(_searchProducts);
    on<ApplyFilters>(_applyFilters);
    on<ToggleWishlist>(_toggleWishlist);
    on<AddToCart>(_addToCart);
  }

  // Future<void> _loadHome(
  //     LoadHome event, Emitter<HomeState> emit) async {
  //   emit(state.copyWith(loading: true));
  //   final products = await repo.getHomeProducts();
  //   emit(state.copyWith(loading: false, products: products));
  // }

  Future<void> _loadHome(
      LoadHome event,
      Emitter<HomeState> emit,
      ) async {
    emit(state.copyWith(loading: true));

    final products = await repo.getHomeProducts();
    final wishlist = await repo.getWishlist();

    emit(state.copyWith(
      loading: false,
      products: products,
      wishlist: wishlist,
    ));
  }




  Future<void> _searchSuggestions(
      SearchQueryChanged event, Emitter<HomeState> emit) async {
    if (event.query.length < 2) return;
    final suggestions = await repo.getSearchSuggestions(event.query);
    emit(state.copyWith(suggestions: suggestions));
  }

  Future<void> _searchProducts(
      SearchSubmitted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(loading: true));
    final products = await repo.searchProducts(event.query);
    emit(state.copyWith(
      loading: false,
      products: products,
      suggestions: [],
    ));
  }

  Future<void> _applyFilters(
      ApplyFilters event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      loading: true,
      minPrice: event.minPrice,
      maxPrice: event.maxPrice,
      minRating: event.minRating,
      brands: event.brands,
    ));

    final products = await repo.getFilteredProducts(
      minPrice: event.minPrice,
      maxPrice: event.maxPrice,
      minRating: event.minRating,
      brands: event.brands,
    );

    emit(state.copyWith(loading: false, products: products));
  }

  Future<void> _toggleWishlist(
      ToggleWishlist event,
      Emitter<HomeState> emit,
      ) async {
    final isWishlisted =
    state.wishlist.contains(event.productId);

    final updated = Set<String>.from(state.wishlist);

    if (isWishlisted) {
      updated.remove(event.productId);
    } else {
      updated.add(event.productId);
    }

    /// Optimistic update
    emit(state.copyWith(wishlist: updated));

    try {
      await repo.toggleWishlist(
        event.productId,
        !isWishlisted,
      );
    } catch (_) {
      /// rollback
      emit(state.copyWith(wishlist: state.wishlist));
    }
  }



  void _addToCart(AddToCart event, Emitter<HomeState> emit) {
    emit(state.copyWith(cartCount: state.cartCount + 1));
  }
}
