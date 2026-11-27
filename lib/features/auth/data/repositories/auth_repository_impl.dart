import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_user_model.dart';

class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({AuthRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSourceImpl();

  final AuthRemoteDataSource _remoteDataSource;

  @override
  AuthUserEntity? getCurrentUser() {
    final user = _remoteDataSource.getCurrentUser();
    return user != null ? AuthUserModel.fromSupabaseUser(user) : null;
  }

  @override
  Future<AuthUserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) {
        throw const AuthFailure('Sesi login tidak ditemukan. Silakan coba lagi.');
      }
      return AuthUserModel.fromSupabaseUser(user);
    } on AuthException catch (e) {
      throw AuthFailure(_mapLoginError(e));
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw const AuthFailure('Terjadi kesalahan jaringan. Silakan coba lagi.');
    }
  }

  @override
  Future<AuthResultEntity> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );
      final user = response.user != null
          ? AuthUserModel.fromSupabaseUser(response.user!)
          : null;
      return AuthResultEntity(
        user: user,
        hasActiveSession: response.session != null,
      );
    } on AuthException catch (e) {
      throw AuthFailure(_mapRegisterError(e));
    } catch (_) {
      throw const AuthFailure('Terjadi kesalahan jaringan. Silakan coba lagi.');
    }
  }

  @override
  Future<void> logout() => _remoteDataSource.signOut();

  static String _mapLoginError(AuthException e) {
    final msg = e.message.toLowerCase();
    if (msg.contains('invalid login credentials')) {
      return 'Email atau password salah.';
    }
    if (msg.contains('email not confirmed')) {
      return 'Email belum dikonfirmasi. Cek inbox atau matikan Confirm Email di Supabase Auth.';
    }
    if (msg.contains('too many requests')) {
      return 'Terlalu banyak percobaan. Silakan tunggu beberapa saat.';
    }
    return e.message.isNotEmpty ? e.message : 'Gagal masuk. Silakan coba lagi.';
  }

  static String _mapRegisterError(AuthException e) {
    final msg = e.message.toLowerCase();
    if (msg.contains('already registered') || msg.contains('already exists')) {
      return 'Email sudah terdaftar. Silakan masuk dengan akun tersebut.';
    }
    if (msg.contains('password')) {
      return 'Password minimal 6 karakter dan tidak terlalu lemah.';
    }
    return e.message.isNotEmpty
        ? e.message
        : 'Gagal mendaftar. Silakan coba lagi.';
  }
}
