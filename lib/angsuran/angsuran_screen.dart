import 'package:flutter/material.dart';
import 'package:mpay_godong/layouts/top_bar.dart';
import 'components/body.dart';

class AngsuranScreen extends StatelessWidget {
  static const String routeName = '/angsuran';

  const AngsuranScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: TopBar(
            title:
            Text('Angsuran')
        ),
        body: SingleChildScrollView(
          child: Body(),
      ),
    );
  }
}
