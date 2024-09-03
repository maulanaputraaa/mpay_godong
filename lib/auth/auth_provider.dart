import 'package:flutter/foundation.dart';
import 'auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> register(String name, String email, String password) async {
    final success = await _authService.register(name, email, password);
    _isAuthenticated = success;
    notifyListeners();
    return success;
  }

  Future<bool> login(String email, String password) async {
    final success = await _authService.login(email, password);
    _isAuthenticated = success;
    notifyListeners();
    return success;
  }

  Future<bool> logout() async {
    try {
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
