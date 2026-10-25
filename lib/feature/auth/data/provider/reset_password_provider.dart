import 'package:flutter/foundation.dart';
import 'package:nuqta/core/helper/validators.dart';
import 'package:nuqta/feature/auth/data/auth_service.dart';
import 'package:nuqta/feature/auth/domain/auth_exception.dart';

enum ResetPasswordStatus { initial, loading, success, error }

class ResetPasswordProvider extends ChangeNotifier {
  final AuthService _authService;

  ResetPasswordStatus _status = ResetPasswordStatus.initial;
  String? _errorMessage;
  String? _successMessage;

  ResetPasswordProvider({AuthService? authService})
    : _authService = authService ?? AuthService();

  ResetPasswordStatus get status => _status;
  bool get isLoading => _status == ResetPasswordStatus.loading;
  bool get isSuccess => _status == ResetPasswordStatus.success;
  bool get hasError => _status == ResetPasswordStatus.error;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  /// Send password reset link to user email with validation
  Future<bool> sendPasswordResetEmail({required String email}) async {
    // 1. Input Validation
    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      _setError(emailError);
      return false;
    }

    // 2. Execution
    _setLoading();
    try {
      await _authService.sendPasswordResetEmail(email: email);
      _status = ResetPasswordStatus.success;
      _errorMessage = null;
      _successMessage =
          'Password reset link has been sent to your email address.';
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Failed to send password reset email. Please try again.');
      return false;
    }
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    if (_status == ResetPasswordStatus.error) {
      _status = ResetPasswordStatus.initial;
    }
    notifyListeners();
  }

  void reset() {
    _status = ResetPasswordStatus.initial;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void _setLoading() {
    _status = ResetPasswordStatus.loading;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _status = ResetPasswordStatus.error;
    notifyListeners();
  }
}
