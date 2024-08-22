import 'package:flutter/material.dart';
import 'login_form.dart';
import 'login_fingerprint.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 90),
            const LoginForm(),
            const SizedBox(height: 20),
            LoginFingerprint(),
            const SizedBox(height: 20),
            const SignUpButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
