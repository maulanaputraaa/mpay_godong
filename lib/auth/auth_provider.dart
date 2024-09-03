import 'package:flutter/foundation.dart';
import 'auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;
  bool _isFingerprintLogin = false; // Tambahan untuk melacak status login fingerprint

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> register(String name, String email, String password) async {
    final success = await _authService.register(name, email, password);
    _isAuthenticated = success;
    _isFingerprintLogin = false; // Set fingerprint login ke false setelah register
    notifyListeners();
    return success;
  }

  Future<bool> login(String email, String password) async {
    final success = await _authService.login(email, password);
    _isAuthenticated = success;
    _isFingerprintLogin = false; // Set fingerprint login ke false setelah login manual
    notifyListeners();
    return success;
  }

  Future<bool> loginWithFingerprint() async {
    final success = await _authService.loginWithFingerprint();
    _isAuthenticated = success;
    _isFingerprintLogin = true; // Set fingerprint login ke true setelah login fingerprint
    notifyListeners();
    return success;
  }

  Future<bool> logout() async {
    try {
      // Cek apakah user login menggunakan fingerprint
      if (_isFingerprintLogin) {
        print('Logout tidak diizinkan karena login menggunakan fingerprint.');
        return false; // Jika ya, return false dan batalkan logout
      }

      final success = await _authService.logout();
      if (success) {
        _isAuthenticated = false;
        notifyListeners();
      }
      return success;
    } catch (e) {
      // Handle error
      print('Logout error: $e');
      return false;
    }
  }

  Future<void> checkAuthStatus() async {
    final token = await _authService.getToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }
}

