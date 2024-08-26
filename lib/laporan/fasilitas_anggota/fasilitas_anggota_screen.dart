import 'package:flutter/material.dart';
import 'components/body.dart';


class FasilitasAnggotaScreen extends StatelessWidget {
  static const String routeName = '/fasilitas_anggota';
  const FasilitasAnggotaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fasilitas Anggota'),
      ),
      body: const FasilitasAnggotaBody(),
    );
  }
}
