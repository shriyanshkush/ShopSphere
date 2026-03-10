// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
//
// class ChatRemoteDataSource {
//   final String baseUrl;
//   final http.Client client;
//
//   ChatRemoteDataSource({required this.baseUrl, http.Client? client})
//       : client = client ?? http.Client();
//
//   Future<Map<String, dynamic>> sendMessage({
//     required String userId,
//     required String message,
//     String? threadId,
//   }) async {
//     final response = await client.post(
//       Uri.parse('$baseUrl/api/chat'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'userId': userId,
//         'message': message,
//         if (threadId != null) 'threadId': threadId,
//       }),
//     );
//
//     return _parseResponse(response);
//   }
//
//   Future<Map<String, dynamic>> getThread(String threadId) async {
//     final response = await client.get(Uri.parse('$baseUrl/api/chat/$threadId'));
//     return _parseResponse(response);
//   }
//
//   Map<String, dynamic> _parseResponse(http.Response response) {
//     final body = response.body.isEmpty
//         ? <String, dynamic>{}
//         : jsonDecode(response.body) as Map<String, dynamic>;
//
//     if (response.statusCode < 200 || response.statusCode >= 300) {
//       final message = body['message']?.toString() ?? 'Request failed (${response.statusCode})';
//       throw Exception(message);
//     }
//
//     return body;
//   }
// }


import 'package:dio/dio.dart';
import '../../../../core/services/api_service.dart';

class ChatRemoteDataSource {
  final Dio dio = ApiService().dio;

  /// Send user message
  Future<Map<String, dynamic>> sendMessage({
    required String userId,
    required String message,
    String? threadId,
  }) async {
    final res = await dio.post(
      '/api/chat',
      data: {
        'userId': userId,
        'message': message,
        if (threadId != null) 'threadId': threadId,
      },
    );

    return res.data as Map<String, dynamic>;
  }

  /// Get full thread
  Future<Map<String, dynamic>> getThread(String threadId) async {
    final res = await dio.get('/api/chat/$threadId');
    return res.data as Map<String, dynamic>;
  }
}