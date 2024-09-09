import 'package:flutter/material.dart';
import 'package:mpay_godong/routes.dart';
import 'package:mpay_godong/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'auth/auth_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mpay Godong',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Lato',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}
