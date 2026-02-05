class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final Map<String, dynamic> user;


  AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });


  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      user: json['user'],
    );
  }
}