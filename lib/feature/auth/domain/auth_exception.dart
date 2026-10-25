import 'package:firebase_auth/firebase_auth.dart';

class AuthException implements Exception {
  final String message;
  final String? code;

  const AuthException({required this.message, this.code});

  factory AuthException.fromFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return AuthException(
          message: 'The email address is badly formatted.',
          code: e.code,
        );
      case 'user-disabled':
        return AuthException(
          message: 'This user account has been disabled.',
          code: e.code,
        );
      case 'user-not-found':
        return AuthException(
          message: 'No user found for that email.',
          code: e.code,
        );
      case 'wrong-password':
        return AuthException(
          message: 'Incorrect password provided.',
          code: e.code,
        );
      case 'invalid-credential':
        return AuthException(
          message: 'Invalid email or password. Please check and try again.',
          code: e.code,
        );
      case 'email-already-in-use':
        return AuthException(
          message: 'An account already exists for that email.',
          code: e.code,
        );
      case 'operation-not-allowed':
        return AuthException(
          message: 'Email and password accounts are not enabled in Firebase.',
          code: e.code,
        );
      case 'weak-password':
        return AuthException(
          message: 'The password provided is too weak.',
          code: e.code,
        );
      case 'too-many-requests':
        return AuthException(
          message: 'Too many unsuccessful attempts. Please try again later.',
          code: e.code,
        );
      case 'network-request-failed':
        return AuthException(
          message: 'Network error. Please check your internet connection.',
          code: e.code,
        );
      case 'requires-recent-login':
        return AuthException(
          message:
              'This operation is sensitive and requires recent authentication. Log in again.',
          code: e.code,
        );
      case 'user-token-expired':
        return AuthException(
          message: 'Session expired. Please log in again.',
          code: e.code,
        );
      default:
        return AuthException(
          message: e.message ?? 'An unexpected authentication error occurred.',
          code: e.code,
        );
    }
  }

  @override
  String toString() => message;
}
