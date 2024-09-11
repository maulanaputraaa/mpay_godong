import 'package:flutter/material.dart';
import 'components/body.dart';

class SaldoScreen extends StatelessWidget {
  static const String routeName = '/simpanan/saldo';

  const SaldoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek Saldo'),
      ),
      body: const SaldoBody(),
    );
  }
}
