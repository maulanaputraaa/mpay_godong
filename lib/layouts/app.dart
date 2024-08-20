import 'package:flutter/material.dart';
import 'package:mpay_godong/layouts/nav_bar.dart';
import 'package:mpay_godong/login/login_screen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../qr_scanner/qr_scan_page.dart';

class AppScreen extends StatefulWidget {
  static const String routeName = '/test';

  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int selected = 0;
  bool heart = false;
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
        child: Icon(
          Icons.qr_code_scanner,
          color: Colors.green,
          size: 34,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: PageView(
          controller: controller,
          children: const [
            Center(child: Text('Simpanan')),
            Center(child: Text('Angsuran')),
            Center(child: Text('Laporan')),
            Center(child: Text('Profile')),
          ],
        ),
      ),
    );
  }
}