import 'package:flutter/foundation.dart';
import 'package:nuqta/core/helper/validators.dart';

class AuthValidationProvider extends ChangeNotifier {
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _nameError;

  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;
  String? get nameError => _nameError;

  bool get hasErrors =>
      _emailError != null ||
      _passwordError != null ||
      _confirmPasswordError != null ||
      _nameError != null;

  String? validateEmail(String? email) {
    _emailError = Validators.validateEmail(email);
    notifyListeners();
    return _emailError;
  }

  String? validatePassword(String? password) {
    _passwordError = Validators.validatePassword(password);
    notifyListeners();
    return _passwordError;
  }

  String? validateConfirmPassword(String? confirmPassword, String password) {
    _confirmPasswordError = Validators.validateConfirmPassword(
      confirmPassword,
      password,
    );
    notifyListeners();
    return _confirmPasswordError;
  }

  String? validateName(String? name) {
    _nameError = Validators.validateName(name);
    notifyListeners();
    return _nameError;
  }

  /// Validates all fields required for Sign In
  bool validateLoginForm({required String email, required String password}) {
    final emailErr = validateEmail(email);
    String? passwordErr;
    if (password.trim().isEmpty) {
      passwordErr = 'Password is required';
      _passwordError = passwordErr;
      notifyListeners();
    } else {
      _passwordError = null;
    }
    return emailErr == null && passwordErr == null;
  }

  /// Validates all fields required for Sign Up
  bool validateSignUpForm({
    required String email,
    required String password,
    required String confirmPassword,
    String? name,
  }) {
    final nameErr = name != null ? validateName(name) : null;
    final emailErr = validateEmail(email);
    final passwordErr = validatePassword(password);
    final confirmErr = validateConfirmPassword(confirmPassword, password);

    return nameErr == null &&
        emailErr == null &&
        passwordErr == null &&
        confirmErr == null;
  }

  /// Validates all fields required for Password Reset
  bool validateResetPasswordForm({required String email}) {
    final emailErr = validateEmail(email);
    return emailErr == null;
  }

  void clearEmailError() {
    _emailError = null;
    notifyListeners();
  }

  void clearPasswordError() {
    _passwordError = null;
    notifyListeners();
  }

  void clearConfirmPasswordError() {
    _confirmPasswordError = null;
    notifyListeners();
  }

  void clearNameError() {
    _nameError = null;
    notifyListeners();
  }

  void clearAllErrors() {
    _emailError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    _nameError = null;
    notifyListeners();
  }
}
