import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'https://godong.niznet.my.id/api';

  Future<bool> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveToken(data['authorisation']['token']);
      return true;
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveToken(data['authorisation']['token']);
      await _saveFingerprintLogin(false);
      return true;
    }
    return false;
  }

  Future<Map<String, dynamic>> loginWithFingerprint() async {
    try {
      final token = await getToken();
      if (token == null) {
        return {'success': false, 'message': 'No token found. Please login with credentials first.'};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/verify_token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        await _saveFingerprintLogin(true);
        return {'success': true, 'message': 'Login successful'};
      } else if (response.statusCode == 401) {
        return {'success': false, 'message': 'Token expired. Please login with credentials.'};
      } else {
        return {'success': false, 'message': 'Server error. Please try again later.'};
      }
    } catch (e) {
      if (e is http.ClientException) {
        return {'success': false, 'message': 'Network error. Please check your connection.'};
      }
      return {'success': false, 'message': 'An unexpected error occurred: ${e.toString()}'};
    }
  }

  Future<bool> logout() async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      await _removeToken();
      await _removeFingerprintLogin();
      return true;
    }
    return false;
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _saveFingerprintLogin(bool isFingerprintLogin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_fingerprint_login', isFingerprintLogin);
  }

  Future<void> _removeFingerprintLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_fingerprint_login');
  }

  Future<bool> isFingerprintLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_fingerprint_login') ?? false;
  }
}
