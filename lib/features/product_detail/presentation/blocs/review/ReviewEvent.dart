abstract class ReviewEvent {}

class LoadReviews extends ReviewEvent {
  final String productId;
  LoadReviews(this.productId);
}

class SubmitReview extends ReviewEvent {
  final String productId;
  final int rating;
  final String comment;

  SubmitReview({
    required this.productId,
    required this.rating,
    required this.comment,
  });
}
