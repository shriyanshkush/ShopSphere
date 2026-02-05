abstract class ProductDetailEvent {}

class LoadProductDetail extends ProductDetailEvent {
  final String productId;
  LoadProductDetail(this.productId);
}

class ToggleWishlist extends ProductDetailEvent {}

class AddToCart extends ProductDetailEvent {}
