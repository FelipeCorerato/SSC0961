import '../models/user.dart';

abstract class AuthenticationService {
  Future<User?> login(String email, String password);
  Future<void> logout();
  Future<User?> register(String email, String password, String name);
  Future<User?> getCurrentUser();
}
