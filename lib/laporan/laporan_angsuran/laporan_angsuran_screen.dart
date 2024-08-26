import 'package:flutter/material.dart';
import 'components/body.dart';

class LaporanAngsuranScreen extends StatelessWidget {
  static const String routeName = '/laporanangsuran';

  const LaporanAngsuranScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Angsuran"),
      ),
      body: const Body(),
    );
  }
}
