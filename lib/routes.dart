import 'package:flutter/material.dart';
import 'package:mpay_godong/layouts/app.dart';
import 'package:mpay_godong/login/login_screen.dart';
import 'package:mpay_godong/simpanan/penarikan/penarikan_screen.dart';
import 'package:mpay_godong/simpanan/saldo/saldo_screen.dart';
import 'package:mpay_godong/simpanan/setoran/setoran_screen.dart';
import 'package:mpay_godong/simpanan/simpanan_screen.dart';
import 'package:mpay_godong/splash_screen/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  AppScreen.routeName: (context) => const AppScreen(),
  SimpananScreen.routeName: (context) => const SimpananScreen(),
  SetoranScreen.routeName: (context) => const SetoranScreen(),
  PenarikanScreen.routeName: (context) => const PenarikanScreen(),
  SaldoScreen.routeName: (context) => const SaldoScreen()
};
