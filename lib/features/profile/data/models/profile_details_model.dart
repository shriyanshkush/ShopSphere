class ProfileDetailsModel {
  final String name;
  final String email;
  final int ordersCount;
  final int wishlistCount;
  final int points;

  const ProfileDetailsModel({
    required this.name,
    required this.email,
    required this.ordersCount,
    required this.wishlistCount,
    required this.points,
  });

  factory ProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};
    final stats = json['stats'] as Map<String, dynamic>? ?? {};

    return ProfileDetailsModel(
      name: user['name']?.toString() ?? 'Guest User',
      email: user['email']?.toString() ?? '',
      ordersCount: (stats['ordersCount'] as num?)?.toInt() ?? 0,
      wishlistCount: (stats['wishlistCount'] as num?)?.toInt() ?? 0,
      points: (stats['points'] as num?)?.toInt() ?? 0,
    );
  }
}
