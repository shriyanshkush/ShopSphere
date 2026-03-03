import 'dart:convert';

import 'package:http/http.dart' as http;

class ChatRemoteDataSource {
  final String baseUrl;
  final http.Client client;

  ChatRemoteDataSource({required this.baseUrl, http.Client? client})
      : client = client ?? http.Client();

  Future<Map<String, dynamic>> sendMessage({
    required String userId,
    required String message,
    String? threadId,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'message': message,
        if (threadId != null) 'threadId': threadId,
      }),
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getThread(String threadId) async {
    final response = await client.get(Uri.parse('$baseUrl/api/chat/$threadId'));
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
