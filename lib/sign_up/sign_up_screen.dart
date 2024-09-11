import 'package:flutter/material.dart';
import '../layouts/top_bar.dart';
import 'components/body.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/sign_up';
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopBar(
          title:
          Text('Sign Up')
      ),
      body: Body(),
    );
  }
}
