class HomeUserModel {
  final String id;
  final String name;
  final String email;

  HomeUserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory HomeUserModel.fromJson(Map<String, dynamic> json) {
    return HomeUserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}