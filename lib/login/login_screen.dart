import 'package:flutter/material.dart';
import 'package:mpay_godong/layouts/top_bar.dart';
import 'components/body.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopBar(title: Text(''),
      ),
      body: Body(),
    );
  }
}
