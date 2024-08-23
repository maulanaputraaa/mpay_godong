import 'package:flutter/material.dart';
import 'components/body.dart';


class TagihanScreen extends StatelessWidget {
  static const String routeName = '/angsuran/tagihan';
  const TagihanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tagihan'),
      ),
      body: const TagihanBody(),
    );
  }
}
