import 'package:dio/dio.dart';
import '../../../../core/services/api_service.dart';
import '../models/auth_response_model.dart';


class AuthRemoteDataSource {
  final Dio dio = ApiService().dio;


  Future<AuthResponseModel> login(String email, String password) async {
    final res = await dio.post('/api/signin', data: {
      'email': email,
      'password': password,
    });
    return AuthResponseModel.fromJson(res.data);
  }


  Future<AuthResponseModel> signup(String name, String email, String password) async {
    final res = await dio.post('/api/signup', data: {
      'name': name,
      'email': email,
      'password': password,
    });
    return AuthResponseModel.fromJson(res.data);
  }
}