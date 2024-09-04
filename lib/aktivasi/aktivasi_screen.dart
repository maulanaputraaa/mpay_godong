import 'package:flutter/material.dart';
import '../layouts/top_bar.dart';
import 'components/body.dart';

class AktivasiScreen extends StatelessWidget {
  static const routeName = '/aktivasi';
  const AktivasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopBar(
          title:
          Text('Aktivasi')
      ),
      body: Body(),
    );
  }
}
