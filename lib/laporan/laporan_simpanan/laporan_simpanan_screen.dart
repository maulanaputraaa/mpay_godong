import 'package:flutter/material.dart';
import 'components/body.dart';

class LaporanSimpananScreen extends StatelessWidget {
  static const String routeName = '/laporansimpanan';

  const LaporanSimpananScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Simpanan"),
      ),
      body: const Body(),
    );
  }
}
