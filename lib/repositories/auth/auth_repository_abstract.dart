import 'models/user.dart';

abstract class AuthRepositoryAbstract {
  Future<AuthData> login({
    required String username,
    required String password,
  });
  Future<AuthData> register({
    required String email,
    required String username,
    required String password,
  });
  Future<void> refreshToken(AuthData user);
  Future<void> logout();
  Future<AuthData> loadUser();
  Future<void> saveUser(AuthData user);
}
