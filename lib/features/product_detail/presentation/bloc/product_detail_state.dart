import '../../data/models/product_detail_model.dart';
import '../../data/models/review_model.dart';

class ProductDetailState {
  final bool loading;
  final ProductDetailModel? product;
  final List<ReviewModel> reviews;
  final bool isWishlisted;

  ProductDetailState({
    this.loading = false,
    this.product,
    this.reviews = const [],
    this.isWishlisted = false,
  });

  ProductDetailState copyWith({
    bool? loading,
    ProductDetailModel? product,
    List<ReviewModel>? reviews,
    bool? isWishlisted,
  }) {
    return ProductDetailState(
      loading: loading ?? this.loading,
      product: product ?? this.product,
      reviews: reviews ?? this.reviews,
      isWishlisted: isWishlisted ?? this.isWishlisted,
    );
  }
}
