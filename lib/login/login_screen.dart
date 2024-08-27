import 'package:flutter/material.dart';
import 'package:mpay_godong/simpanan/simpanan_screen.dart';
import 'package:provider/provider.dart';
import '../auth/auth_provider.dart';
import 'components/body.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Cek status autentikasi
        if (authProvider.isAuthenticated) {
          return const SimpananScreen(); // Tampilkan HomeScreen jika sudah login
        } else {
          return const Scaffold(
            body: Body(), // Tampilkan LoginScreen jika belum login
          );
        }
      },
    );
  }
}
