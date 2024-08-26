import 'package:flutter/material.dart';
import 'components/body.dart';

class RekapLaporanScreen extends StatelessWidget {
  static const String routeName = '/rekaplaporan';

  const RekapLaporanScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rekap Laporan"),
      ),
      body: const Body(),
    );
  }
}
