import 'package:flutter/material.dart';
import 'package:mpay_godong/layouts/top_bar.dart';
import 'components/body.dart';

class SimpananScreen extends StatelessWidget {
  static const String routeName = '/simpanan';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopBar(
          title:
          Text('Simpanan')
      ),
      body: Body()
    );
  }
}
