import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class NavBar extends StatefulWidget {
  final int initialIndex;
  final Function(int) onTap;
  final PageController controller;

  const NavBar({
    super.key,
    required this.initialIndex,
    required this.onTap,
    required this.controller,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late int selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return StylishBottomBar(
      option: AnimatedBarOptions(
        iconStyle: IconStyle.animated,
      ),
      items: [
        BottomBarItem(
          icon: const Icon(Icons.savings_rounded),
          title: const Text('Simpanan'),
        ),
        BottomBarItem(
          icon: const Icon(Icons.credit_card_rounded),
          title: const Text('Angsuran'),
        ),
        BottomBarItem(
          icon: const Icon(Icons.receipt_long_rounded),
          title: const Text('Laporan'),
        ),
        BottomBarItem(
          icon: const Icon(Icons.settings_rounded),
          title: const Text('Pengaturan'),
        ),
      ],
      hasNotch: true,
      fabLocation: StylishBarFabLocation.center,
      currentIndex: selected,
      notchStyle: NotchStyle.circle,
      onTap: (index) {
        if (index == selected) return;
        widget.controller.jumpToPage(index);
        setState(() {
          selected = index;
        });
        widget.onTap(index);
      },
    );
  }
}
