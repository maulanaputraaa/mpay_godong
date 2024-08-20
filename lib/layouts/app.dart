import 'package:flutter/material.dart';
import 'package:mpay_godong/layouts/nav_bar.dart';
import 'package:mpay_godong/login/login_screen.dart';
import 'package:mpay_godong/qr_scanner/qr_scan_page.dart';

class AppScreen extends StatefulWidget {
  static const String routeName = '/home';
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
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
      bottomNavigationBar: NavBar(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRScanPage()),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.qr_code_scanner,
          color: Colors.green,
          size: 34,
        ),
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
        return LoginScreen();
      case 1:
        return const Center(child: Text('Star'));
      case 2:
        return const Center(child: Text('Style'));
      case 3:
        return const Center(child: Text('Profile'));
      default:
        return const SizedBox.shrink();
    }
  }
}
