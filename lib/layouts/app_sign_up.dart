import 'package:flutter/material.dart';
import 'package:mpay_godong/aktivasi/aktivasi_screen.dart';
import 'package:mpay_godong/sign_up/sign_up_screen.dart';

import 'nav_bar_sign_up.dart';

class AppScreenSignUp extends StatefulWidget {
  static const String routeName = '/signup';
  const AppScreenSignUp({super.key});

  @override
  State<AppScreenSignUp> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreenSignUp> {
  int selected = 0;
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: NavBarSignUp(
        initialIndex: selected,
        onTap: (index) {
          setState(() {
            selected = index;
          });
          controller.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        controller: controller,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              selected = index;
            });
          },
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: KeyedSubtree(
                key: ValueKey<int>(selected),
                child: _getPage(selected),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const SignUpScreen();
      case 1:
        return const AktivasiScreen();
      default:
        return const SizedBox.shrink();
    }
  }
}
