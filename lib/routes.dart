import 'package:flutter/material.dart';
import 'package:mpay_godong/layouts/app.dart';
import 'package:mpay_godong/login/login_screen.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => LoginScreen(),
  AppScreen.routeName: (context) => AppScreen(),
};
