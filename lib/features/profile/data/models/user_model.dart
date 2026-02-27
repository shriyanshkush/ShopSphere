class UserModel {
  final String id;
  final String name;
  final String email;
  final String type;
  final String? address;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      type: json['type'] ?? '',
      address: json['address'],
    );
  }
}