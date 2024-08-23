import 'package:flutter/material.dart';
import 'components/body_feature.dart';


class AngsuranFeatureScreen extends StatelessWidget {
  static const String routeName = '/angsuran feature';
  const AngsuranFeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Angsuran'),
      ),
      body: const BodyFeature(),
    );
  }
}
