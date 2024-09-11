import 'package:flutter/material.dart';
import 'package:mpay_godong/layouts/top_bar.dart';
import 'components/body.dart';

class NasabahScreen extends StatelessWidget {
  static const String routeName = '/daftar_nasabah';

  const NasabahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopBar(
          title:
          Text('Daftar Nasabah')),
      body: Body(),
    );
  }
}
