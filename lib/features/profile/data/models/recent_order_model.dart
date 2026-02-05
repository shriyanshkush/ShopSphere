class RecentOrderModel {
  final String id;
  final String title;
  final String status;
  final String image;
  final bool canTrack;
  final bool canReview;

  const RecentOrderModel({
    required this.id,
    required this.title,
    required this.status,
    required this.image,
    this.canTrack = false,
    this.canReview = false,
  });

  factory RecentOrderModel.fromJson(Map<String, dynamic> json) {
    return RecentOrderModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      canTrack: json['canTrack'] == true,
      canReview: json['canReview'] == true,
    );
  }
}
