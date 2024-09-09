import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUrl = 'https://godong.niznet.my.id/api';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

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
      await _saveUserCredentials(email, password);
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
      await _saveUserCredentials(email, password);

      Fluttertoast.showToast(
        msg: "Login berhasil",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      return true;
    } else {
      Fluttertoast.showToast(
        msg: "Login gagal. Periksa kembali email dan password Anda.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      return false;
    }
  }

  Future<Map<String, dynamic>> loginWithFingerprint() async {
    try {
      final credentials = await _getUserCredentials();
      if (credentials == null) {
        return {
          'success': false,
          'message': 'Harap login dengan email dan password terlebih dahulu.'
        };
      }

      final success = await login(credentials['email']!, credentials['password']!);
      if (success) {
        await _saveFingerprintLogin(true);
        return {'success': true, 'message': 'Login berhasil'};
      } else {
        return {'success': false, 'message': "Login gagal. Harap coba lagi nanti."};
      }
    } catch (e) {
      if (e is http.ClientException) {
        return {'success': false, 'message': 'Kesalahan jaringan. Harap periksa koneksi Anda.'};
      }
      return {'success': false, 'message': 'Terjadi kesalahan tak terduga: ${e.toString()}'};
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
      await _removeFingerprintLogin(); // Optional: remove fingerprint flag if necessary
      return true;
    }
    return false;
  }

  Future<void> _saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<void> _removeToken() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> _saveFingerprintLogin(bool isFingerprintLogin) async {
    await _storage.write(key: 'is_fingerprint_login', value: isFingerprintLogin.toString());
  }

  Future<void> _removeFingerprintLogin() async {
    await _storage.delete(key: 'is_fingerprint_login');
  }

  Future<bool> isFingerprintLogin() async {
    final value = await _storage.read(key: 'is_fingerprint_login');
    return value == 'true';
  }

  Future<void> _saveUserCredentials(String email, String password) async {
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'password', value: password);
  }

  Future<Map<String, String>?> _getUserCredentials() async {
    final email = await _storage.read(key: 'email');
    final password = await _storage.read(key: 'password');
    if (email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return null;
  }
}
