import '../../../data/models/review_model.dart';

class ReviewState {
  final bool loading;
  final bool success;
  final List<ReviewModel> reviews;
  final String? error;

  ReviewState({
    this.loading = false,
    this.success = false,
    this.reviews = const [],
    this.error,
  });

  ReviewState copyWith({
    bool? loading,
    bool? success,
    List<ReviewModel>? reviews,
    String? error,
  }) {
    return ReviewState(
      loading: loading ?? this.loading,
      success: success ?? this.success,
      reviews: reviews ?? this.reviews,
      error: error,
    );
  }
}
