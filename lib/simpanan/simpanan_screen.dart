import 'package:flutter/material.dart';
import 'package:mpay_godong/layouts/top_bar.dart';
import 'components/body.dart';
import 'components/simpanan_menu.dart';

class SimpananScreen extends StatelessWidget {
  static const String routeName = '/simpanan';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
          title:
          Text('Simpanan')
      ),
      body: Column(
        children: <Widget>[
          SimpananMenu(),
          Expanded(child: Body()),
        ],
      ),
    );
  }
}
