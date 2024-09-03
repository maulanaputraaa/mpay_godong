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
      await _saveFingerprintLogin(false); // Menyimpan status login non-fingerprint
      return true;
    }
    return false;
  }

  Future<bool> loginWithFingerprint() async {
    // Implementasi autentikasi fingerprint (disesuaikan dengan library yang digunakan)
    // Misalnya, jika autentikasi fingerprint berhasil:
    final fingerprintAuthSuccess = true; // Gantilah dengan implementasi fingerprint Anda

    if (fingerprintAuthSuccess) {
      final token = await getToken(); // Menggunakan token yang sudah ada
      if (token != null) {
        await _saveFingerprintLogin(true); // Menyimpan status login fingerprint
        return true;
      }
    }
    return false;
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
      await _removeFingerprintLogin(); // Hapus status login fingerprint saat logout
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
