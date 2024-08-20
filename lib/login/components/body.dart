import 'package:flutter/material.dart';
import 'login_form.dart';
import 'login_fingerprint.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          LoginForm(),
          SizedBox(height: 20),
          LoginFingerprint(),
        ],
      ),
    );
  }
}