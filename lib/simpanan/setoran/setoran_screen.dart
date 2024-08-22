import 'package:flutter/material.dart';
import 'components/body.dart';


class SetoranScreen extends StatelessWidget {
  static const String routeName = '/simpanan/setoran';
  const SetoranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setoran'),
      ),
      body: const SetoranBody(),
    );
  }
}
