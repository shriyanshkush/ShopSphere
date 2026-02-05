import '../../data/models/product_detail_model.dart';
import '../../data/models/review_model.dart';

class ProductDetailState {
  final bool loading;
  final ProductDetailModel? product;
  final List<ReviewModel> reviews;

  ProductDetailState({
    this.loading = false,
    this.product,
    this.reviews = const [],
  });

  ProductDetailState copyWith({
    bool? loading,
    ProductDetailModel? product,
    List<ReviewModel>? reviews,
  }) {
    return ProductDetailState(
      loading: loading ?? this.loading,
      product: product ?? this.product,
      reviews: reviews ?? this.reviews,
    );
  }
}
