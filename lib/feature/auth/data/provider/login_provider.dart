import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:nuqta/core/helper/validators.dart';
import 'package:nuqta/feature/auth/data/auth_service.dart';
import 'package:nuqta/feature/auth/domain/auth_exception.dart';

enum LoginStatus { initial, loading, success, error }

class LoginProvider extends ChangeNotifier {
  final AuthService _authService;

  LoginStatus _status = LoginStatus.initial;
  String? _errorMessage;
  User? _user;

  LoginProvider({AuthService? authService})
    : _authService = authService ?? AuthService();

  LoginStatus get status => _status;
  bool get isLoading => _status == LoginStatus.loading;
  bool get isSuccess => _status == LoginStatus.success;
  bool get hasError => _status == LoginStatus.error;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  /// Sign In with email and password
  Future<bool> signIn({required String email, required String password}) async {
    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      _setError(emailError);
      return false;
    }

    if (password.trim().isEmpty) {
      _setError('Password is required');
      return false;
    }

    _setLoading();
    try {
      final credential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = credential.user;
      _status = LoginStatus.success;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred during login. Please try again.');
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    if (_status == LoginStatus.error) {
      _status = LoginStatus.initial;
    }
    notifyListeners();
  }

  void reset() {
    _status = LoginStatus.initial;
    _errorMessage = null;
    _user = null;
    notifyListeners();
  }

  void _setLoading() {
    _status = LoginStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _status = LoginStatus.error;
    notifyListeners();
  }
}
