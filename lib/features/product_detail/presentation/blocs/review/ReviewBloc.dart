import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/product_detail_repository.dart';
import 'ReviewEvent.dart';
import 'ReviewState.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ProductDetailRepository repo;

  ReviewBloc(this.repo) : super(ReviewState()) {
    on<SubmitReview>(_submit);
    on<LoadReviews>(_load);
  }

  Future<void> _submit(
      SubmitReview e,
      Emitter<ReviewState> emit,
      ) async {
    emit(state.copyWith(loading: true, success: false, error: null));
    try {
      await repo.addReview(
        productId: e.productId,
        rating: e.rating,
        comment: e.comment,
      );

      emit(state.copyWith(loading: false, success: true));
    } catch (err) {
      emit(state.copyWith(loading: false, success: false, error: err.toString()));
    }
  }

  Future<void> _load(
      LoadReviews e,
      Emitter<ReviewState> emit,
      ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final reviews = await repo.getReviews(e.productId);

      emit(state.copyWith(
        loading: false,
        reviews: reviews,
      ));
    } catch (err) {
      emit(state.copyWith(loading: false, error: err.toString()));
    }
  }
}
