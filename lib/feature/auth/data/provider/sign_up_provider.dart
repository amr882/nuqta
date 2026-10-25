import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:nuqta/core/helper/validators.dart';
import 'package:nuqta/feature/auth/data/auth_service.dart';
import 'package:nuqta/feature/auth/domain/auth_exception.dart';

enum SignUpStatus { initial, loading, success, error }

class SignUpProvider extends ChangeNotifier {
  final AuthService _authService;

  SignUpStatus _status = SignUpStatus.initial;
  String? _errorMessage;
  String? _successMessage;
  User? _user;

  SignUpProvider({AuthService? authService})
    : _authService = authService ?? AuthService();

  SignUpStatus get status => _status;
  bool get isLoading => _status == SignUpStatus.loading;
  bool get isSuccess => _status == SignUpStatus.success;
  bool get hasError => _status == SignUpStatus.error;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  User? get user => _user;

  /// Sign Up with input validation and verification email dispatch
  Future<bool> signUp({
    required String email,
    required String password,
    required String confirmPassword,
    String? name,
  }) async {
    // 1. Input Validation
    if (name != null) {
      final nameError = Validators.validateName(name);
      if (nameError != null) {
        _setError(nameError);
        return false;
      }
    }

    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      _setError(emailError);
      return false;
    }

    final passwordError = Validators.validatePassword(password);
    if (passwordError != null) {
      _setError(passwordError);
      return false;
    }

    final confirmError = Validators.validateConfirmPassword(
      confirmPassword,
      password,
    );
    if (confirmError != null) {
      _setError(confirmError);
      return false;
    }

    // 2. Execution
    _setLoading();
    try {
      final credential = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        displayName: name,
        sendVerification: true,
      );
      _user = credential.user;
      _status = SignUpStatus.success;
      _errorMessage = null;
      _successMessage =
          'Account created successfully! A verification email has been sent.';
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError(
        'An unexpected error occurred during sign up. Please try again.',
      );
      return false;
    }
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    if (_status == SignUpStatus.error) {
      _status = SignUpStatus.initial;
    }
    notifyListeners();
  }

  void reset() {
    _status = SignUpStatus.initial;
    _errorMessage = null;
    _successMessage = null;
    _user = null;
    notifyListeners();
  }

  void _setLoading() {
    _status = SignUpStatus.loading;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _status = SignUpStatus.error;
    notifyListeners();
  }
}
