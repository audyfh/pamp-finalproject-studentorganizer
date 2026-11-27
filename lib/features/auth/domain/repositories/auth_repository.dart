import '../entities/auth_user_entity.dart';

abstract class AuthRepository {
  AuthUserEntity? getCurrentUser();

  Future<AuthUserEntity> login({
    required String email,
    required String password,
  });

  Future<AuthResultEntity> register({
    required String fullName,
    required String email,
    required String password,
  });

  Future<void> logout();
}
