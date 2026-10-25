import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:nuqta/feature/auth/data/auth_service.dart';
import 'package:nuqta/feature/auth/domain/auth_exception.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  StreamSubscription<User?>? _authSubscription;

  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;
  String? _successMessage;
  User? _currentUser;
  bool _isEmailVerified = false;

  AuthProvider({AuthService? authService})
    : _authService = authService ?? AuthService() {
    _init();
  }

  AuthStatus get status => _status;
  bool get isLoading => _status == AuthStatus.loading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  User? get currentUser => _currentUser;
  bool get isEmailVerified => _isEmailVerified;

  void _init() {
    _currentUser = _authService.currentUser;
    _isEmailVerified = _authService.isEmailVerified;
    _status = _currentUser != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;

    _authSubscription = _authService.authStateChanges.listen((user) {
      _currentUser = user;
      _isEmailVerified = user?.emailVerified ?? false;
      _status = user != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated;
      notifyListeners();
    });
  }

  /// Resends email verification to the currently logged in user
  Future<bool> sendEmailVerification() async {
    _setLoading();
    try {
      await _authService.sendEmailVerification();
      _successMessage = 'Verification link sent to your email.';
      _status = _currentUser != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Failed to send verification email. Please try again.');
      return false;
    }
  }

  /// Reloads user state from Firebase and updates email verification status
  Future<bool> checkEmailVerified() async {
    try {
      await _authService.reloadUser();
      _currentUser = _authService.currentUser;
      _isEmailVerified = _authService.isEmailVerified;
      notifyListeners();
      return _isEmailVerified;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Failed to refresh user profile.');
      return false;
    }
  }

  /// Signs out the user and resets session state
  Future<void> signOut() async {
    _setLoading();
    try {
      await _authService.signOut();
      _currentUser = null;
      _isEmailVerified = false;
      _status = AuthStatus.unauthenticated;
      _errorMessage = null;
      _successMessage = null;
      notifyListeners();
    } on AuthException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Failed to sign out. Please try again.');
    }
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _status = AuthStatus.error;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
