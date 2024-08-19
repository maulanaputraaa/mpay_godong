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
      option: DotBarOptions(
        dotStyle: DotStyle.circle,
      ),
      items: [
        BottomBarItem(
          icon: const Icon(
            Icons.house_outlined,
          ),
          selectedIcon: const Icon(Icons.house_rounded),
          selectedColor: Colors.teal,
          unSelectedColor: Colors.grey,
          title: const Text('Home'),
          badge: const Text('9+'),
          showBadge: true,
          badgeColor: Colors.purple,
          badgePadding: const EdgeInsets.only(left: 4, right: 4),
        ),
        BottomBarItem(
          icon: const Icon(Icons.star_border_rounded),
          selectedIcon: const Icon(Icons.star_rounded),
          selectedColor: Colors.red,
          title: const Text('Star'),
        ),
        BottomBarItem(
          icon: const Icon(
            Icons.style_outlined,
          ),
          selectedIcon: const Icon(
            Icons.style,
          ),
          selectedColor: Colors.deepOrangeAccent,
          title: const Text('Style'),
        ),
        BottomBarItem(
          icon: const Icon(
            Icons.person_outline,
          ),
          selectedIcon: const Icon(
            Icons.person,
          ),
          selectedColor: Colors.deepPurple,
          title: const Text('Profile'),
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
