import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class NavBarSignUp extends StatefulWidget {
  final int initialIndex;
  final Function(int) onTap;
  final PageController controller;

  const NavBarSignUp({
    super.key,
    required this.initialIndex,
    required this.onTap,
    required this.controller,
  });

  @override
  State<NavBarSignUp> createState() => _NavBarState();
}

class _NavBarState extends State<NavBarSignUp> {
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
          icon: const Icon(Icons.person_add_outlined),
          title: const Text('Register'),
        ),
        BottomBarItem(
          icon: const Icon(Icons.check_circle_outline),
          title: const Text('Aktivasi'),
        ),
      ],
      hasNotch: true,
      fabLocation: StylishBarFabLocation.center,
      currentIndex: selected,
      notchStyle: NotchStyle.circle,
      onTap: (index) {
        if (index == selected) return;
        widget.controller.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          selected = index;
        });
        widget.onTap(index);
      },
    );
  }
}
