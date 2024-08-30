import 'package:flutter/material.dart';
import 'package:mpay_godong/layouts/top_bar.dart';
import 'components/body.dart';

class ContactScreen extends StatelessWidget {
  static const String routeName = '/daftar_nasabah';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(
          title:
          Text('Daftar Nasabah')),
      body: Body(),
    );
  }
}
