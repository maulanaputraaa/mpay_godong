import 'package:flutter/material.dart';
import 'package:mpay_godong/routes.dart';
import 'package:mpay_godong/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mpay_godong/models/user.dart';

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
    final User user = User(email: 'admin@example.com', password: 'password');
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('email', user.email);
      prefs.setString('password', user.password);
    });

    return MaterialApp(
      title: 'Mpay Godong',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}
