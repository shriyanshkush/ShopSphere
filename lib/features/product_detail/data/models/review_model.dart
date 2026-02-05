class ReviewModel {
  final String userName;
  final double rating;
  final String comment;

  ReviewModel({
    required this.userName,
    required this.rating,
    required this.comment,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      userName: json['userName'],
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] ?? '',
    );
  }
}
