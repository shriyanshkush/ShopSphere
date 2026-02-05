import 'package:dio/dio.dart';
import '../../common/constants/base_url.dart';
import 'auth_local_storage.dart';

class ApiService {
  final Dio dio;
  final AuthLocalStorage _authStorage = AuthLocalStorage();

  ApiService()
      : dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _authStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['x-auth-token'] = token; // ✅ backend expects this
          }

          // 🟢 REQUEST LOG
          print('📤 [${options.method}] ${options.uri}');
          print('🔑 Token: ${token != null && token.isNotEmpty ? "Attached ✅" : "Missing ❌"}');
          if (options.queryParameters.isNotEmpty) {
            print('🔍 Query: ${options.queryParameters}');
          }
          if (options.data != null) {
            print('📦 Body: ${options.data}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('⬅️ [${response.statusCode}] ${response.requestOptions.uri}');
          print('📨 Response: ${response.data}');
          handler.next(response);
        },
        onError: (DioException e, handler) async {

          // 🔴 ERROR LOG
          print('❌ [${e.response?.statusCode}] ${e.requestOptions.uri}');
          print('📭 Error: ${e.response?.data ?? e.message}');

          if (e.response?.statusCode == 401) {
            print('🔄 Attempting token refresh...');
            final refreshed = await _tryRefreshToken();
            if (refreshed) {

              final token = await _authStorage.getToken();
              e.requestOptions.headers['x-auth-token'] = token;
              print('🔁 Retrying request...');
              final response = await dio.fetch(e.requestOptions);
              return handler.resolve(response);
            } else{
              print('🚪 Token refresh failed, user must login again');
            }
          }
          handler.next(e);
        },
      ),
    );
  }

  Future<bool> _tryRefreshToken() async {
    try {
      final user = await _authStorage.getUser();
      if (user == null || user.refreshToken.isEmpty) return false;

      final response = await dio.post(
        '/api/refresh-token',
        data: {'refreshToken': user.refreshToken},
      );

      final accessToken = response.data['accessToken'];
      if (accessToken != null) {
        await _authStorage.saveToken(accessToken);
        print('✅ Token refreshed successfully');
        return true;
      }
    } catch (_) {}
    return false;
  }
}
