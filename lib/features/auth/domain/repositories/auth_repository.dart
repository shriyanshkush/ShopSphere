abstract class AuthRepository {
  Future<void> login(String email, String password);
  Future<void> signup(String name, String email, String password);
  Future<bool> isLoggedIn();
}