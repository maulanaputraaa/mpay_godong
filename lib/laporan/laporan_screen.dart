import 'package:flutter/material.dart';
import 'package:mpay_godong/layouts/top_bar.dart';
import '../laporan/components/body.dart';


class LaporanScreen extends StatelessWidget {
  static const String routeName = '/laporan';

  const LaporanScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: TopBar(
            title:
            Text('Laporan'),
            isSettingsPage: true,
        ),
        body: Body()
    );
  }
}
