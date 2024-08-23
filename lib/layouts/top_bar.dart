import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget title;
  final Widget? action;
  final bool isSettingsPage;

  const TopBar({
    super.key,
    this.leading,
    required this.title,
    this.action,
    this.isSettingsPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      leading: leading,
      actions: [
        if (isSettingsPage)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Tambahkan logika logout di sini
              Navigator.of(context).pushNamed('/login');
            },
          ),
        if (action != null) action!,
      ],
      backgroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
