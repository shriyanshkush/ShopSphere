import '../../../../core/services/auth_local_storage.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';


class AuthRepositoryImpl implements AuthRepository {
  final _remote = AuthRemoteDataSource();
  final _local = AuthLocalStorage();


  @override
  Future<void> login(String email, String password) async {
    final res = await _remote.login(email, password);
    await _local.saveToken(res.accessToken);
    await _local.saveRefreshToken(res.refreshToken);
    await _local.saveUser(AuthUser.fromJson({...res.user, 'refreshToken': res.refreshToken}));
  }


  @override
  Future<void> signup(String name, String email, String password) async {
    final res = await _remote.signup(name, email, password);
    await _local.saveToken(res.accessToken);
    await _local.saveRefreshToken(res.refreshToken);
    await _local.saveUser(AuthUser.fromJson({...res.user, 'refreshToken': res.refreshToken}));
  }

  @override
  Future<bool> isLoggedIn() => _local.isLoggedIn();
}