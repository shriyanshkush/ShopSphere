import '../../../data/models/review_model.dart';

class ReviewState {
  final bool loading;
  final bool success;
  final List<ReviewModel> reviews;

  ReviewState({
    this.loading = false,
    this.success = false,
    this.reviews = const [],
  });

  ReviewState copyWith({
    bool? loading,
    bool? success,
    List<ReviewModel>? reviews,
  }) {
    return ReviewState(
      loading: loading ?? this.loading,
      success: success ?? this.success,
      reviews: reviews ?? this.reviews,
    );
  }
}
