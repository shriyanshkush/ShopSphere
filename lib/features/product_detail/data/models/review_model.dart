class ReviewModel {
  final String userName;
  final double rating;
  final String comment;
  final DateTime? createdAt;

  ReviewModel({
    required this.userName,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      userName: json['userName'],
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'].toString()),
    );
  }
}
