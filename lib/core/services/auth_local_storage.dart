import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 🔐 Handles auth persistence (token + user)
/// Single source of truth for authentication state
class AuthLocalStorage {
  static const _accessTokenKey = 'ACCESS_TOKEN';
  static const _refreshTokenKey = 'REFRESH_TOKEN';
  static const _userKey = 'AUTH_USER';

  /// =========================
  /// TOKEN METHODS
  /// =========================

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  /// =========================
  /// USER METHODS
  /// =========================

  Future<void> saveUser(AuthUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<AuthUser?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userKey);
    if (data == null) return null;
    return AuthUser.fromJson(jsonDecode(data));
  }

  /// =========================
  /// CLEAR METHODS
  /// =========================

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }


}

/// =========================
/// AUTH USER MODEL (LOCAL)
/// =========================
/// Lightweight model only for persistence
class AuthUser {
  final String id;
  final String name;
  final String email;
  final String type;
  final String refreshToken;

  AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    required this.refreshToken,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      type: json['type'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'type': type,
      'refreshToken': refreshToken,
    };
  }
}
