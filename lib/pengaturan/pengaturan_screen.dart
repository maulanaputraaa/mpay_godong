import 'package:flutter/material.dart';
import 'package:mpay_godong/layouts/top_bar.dart';
import '../pengaturan/components/body.dart';

class PengaturanScreen extends StatelessWidget {
  static const String routeName = '/pengaturan';

  const PengaturanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: TopBar(
            title:
            Text('Pengaturan'),
            isSettingsPage: true,
        ),
      body: SingleChildScrollView(
        child: Body(),
      ),
    );
  }
}
