import 'package:flutter/material.dart';
import 'components/body.dart';


class PenarikanScreen extends StatelessWidget {
  static const String routeName = '/simpanan/penarikan';
  const PenarikanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penarikan'),
      ),
      body: const PenarikanBody(),
    );
  }
}
