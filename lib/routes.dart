import 'package:flutter/material.dart';
import 'package:mpay_godong/layouts/app.dart';
import 'package:mpay_godong/login/login_screen.dart';
import 'package:mpay_godong/simpanan/simpanan_screen.dart';
import 'package:mpay_godong/splash_screen/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  AppScreen.routeName: (context) => const AppScreen(),
  SimpananScreen.routeName: (context) => SimpananScreen()
};
