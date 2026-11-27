import 'package:flutter/foundation.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    AuthRepository? repository,
    LoginUseCase? loginUseCase,
    RegisterUseCase? registerUseCase,
    LogoutUseCase? logoutUseCase,
    GetCurrentUserUseCase? getCurrentUserUseCase,
  }) : this._internal(
          repository ?? AuthRepositoryImpl(),
          loginUseCase: loginUseCase,
          registerUseCase: registerUseCase,
          logoutUseCase: logoutUseCase,
          getCurrentUserUseCase: getCurrentUserUseCase,
        );

  AuthProvider._internal(
    AuthRepository repo, {
    LoginUseCase? loginUseCase,
    RegisterUseCase? registerUseCase,
    LogoutUseCase? logoutUseCase,
    GetCurrentUserUseCase? getCurrentUserUseCase,
  })  : _loginUseCase = loginUseCase ?? LoginUseCase(repo),
        _registerUseCase = registerUseCase ?? RegisterUseCase(repo),
        _logoutUseCase = logoutUseCase ?? LogoutUseCase(repo),
        _getCurrentUserUseCase =
            getCurrentUserUseCase ?? GetCurrentUserUseCase(repo);

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  bool _isLoading = false;
  String? _errorMessage;
  AuthUserEntity? _currentUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AuthUserEntity? get currentUser => _currentUser ?? _getCurrentUserUseCase();

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _loginUseCase(email: email, password: password);
      return true;
    } on AuthFailure catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (_) {
      _errorMessage = 'Gagal masuk. Silakan coba lagi.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<AuthResultEntity?> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _registerUseCase(
        fullName: fullName,
        email: email,
        password: password,
      );
      if (result.hasActiveSession) {
        _currentUser = result.user;
      }
      return result;
    } on AuthFailure catch (e) {
      _errorMessage = e.message;
      return null;
    } catch (_) {
      _errorMessage = 'Gagal mendaftar. Silakan coba lagi.';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _logoutUseCase();
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
