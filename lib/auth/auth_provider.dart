import 'package:flutter/foundation.dart';
import 'auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;
  bool _isFingerprintLogin = false;
  String _lastErrorMessage = '';

  bool get isAuthenticated => _isAuthenticated;
  bool get isFingerprintLogin => _isFingerprintLogin;
  String get lastErrorMessage => _lastErrorMessage;

  Future<bool> register(String name, String email, String password) async {
    final success = await _authService.register(name, email, password);
    _isAuthenticated = success;
    _isFingerprintLogin = false;
    notifyListeners();
    return success;
  }

  Future<bool> login(String email, String password) async {
    final success = await _authService.login(email, password);
    _isAuthenticated = success;
    _isFingerprintLogin = false;
    notifyListeners();
    return success;
  }

  Future<bool> loginWithFingerprint() async {
    print('Attempting login with fingerprint');

    final result = await _authService.loginWithFingerprint();
    _isAuthenticated = result['success'];
    _isFingerprintLogin = result['success'];
    _lastErrorMessage = result['success'] ? '' : result['message'];

    print('Login with fingerprint result: ${result['success']}');
    if (!result['success']) {
      print('Login error: ${result['message']}');
    }

    notifyListeners();
    return result['success'];
  }

  Future<bool> logout() async {
    try {
      final success = await _authService.logout();
      if (success) {
        _isAuthenticated = false;
        _isFingerprintLogin = false;
        notifyListeners();
      }
      return success;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }

  Future<void> checkAuthStatus() async {
    final token = await _authService.getToken();
    _isAuthenticated = token != null;
    _isFingerprintLogin = await _authService.isFingerprintLogin();
    notifyListeners();
  }
}