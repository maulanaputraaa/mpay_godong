import 'package:flutter/material.dart';
import 'package:mpay_godong/login/login_screen.dart';
import 'package:mpay_godong/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mpay Godong',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routeName,
      routes: routes,
    );
  }
}
