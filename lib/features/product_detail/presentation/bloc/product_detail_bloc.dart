import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/product_detail_repository.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc
    extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductDetailRepository repo;
  late String productId;

  ProductDetailBloc(this.repo) : super(ProductDetailState()) {
    on<LoadProductDetail>(_load);
    on<ToggleWishlist>(_wishlist);
    on<AddToCart>(_cart);
  }

  Future<void> _load(
      LoadProductDetail e, Emitter<ProductDetailState> emit) async {
    productId = e.productId;
    emit(state.copyWith(loading: true));

    final res = await repo.getProductDetail(e.productId);

    final wishlists= await repo.getWishlist();



    emit(state.copyWith(
      loading: false,
      product: res.product,
      reviews: res.reviews,
      isWishlisted: wishlists.contains(productId)
    ));

  }

  Future<void> _wishlist(
      ToggleWishlist e, Emitter<ProductDetailState> emit) async {
    await repo.toggleWishlist(productId,!state.isWishlisted);
    emit(state.copyWith(isWishlisted: !state.isWishlisted));
  }

  Future<void> _cart(AddToCart e, Emitter<ProductDetailState> emit) async {
    await repo.addToCart(productId);
  }
}
