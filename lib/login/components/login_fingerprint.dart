import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import '../../auth/auth_provider.dart';
import '../../layouts/app.dart';

class LoginFingerprint extends StatelessWidget {
  final LocalAuthentication auth = LocalAuthentication();

  LoginFingerprint({super.key});

  Future<void> _authenticate(BuildContext context) async {
    bool isBiometricSupported = await auth.isDeviceSupported();
    bool canCheckBiometrics = await auth.canCheckBiometrics;

    if (!isBiometricSupported || !canCheckBiometrics) {
      Fluttertoast.showToast(
        msg: 'Autentikasi biometrik tidak didukung pada perangkat ini',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Pindai sidik jari Anda untuk masuk',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Kesalahan autentikasi: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    if (authenticated) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool loginSuccess = await authProvider.loginWithFingerprint();
      if (loginSuccess) {
        Fluttertoast.showToast(
          msg: 'Autentikasi berhasil',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          textColor: Colors.white,
          backgroundColor: Colors.green,
        );
        Navigator.pushReplacementNamed(context, AppScreen.routeName);
      } else {
        Fluttertoast.showToast(
          msg: authProvider.lastErrorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          textColor: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Autentikasi gagal',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text('Atau Masuk Menggunakan Sidik Jari'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _authenticate(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: const Icon(
            Icons.fingerprint,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
