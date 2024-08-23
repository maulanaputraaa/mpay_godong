import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget title;
  final Widget? action;
  final bool isSettingsPage; // Menambahkan parameter untuk memeriksa apakah halaman ini adalah pengaturan

  const TopBar({
    super.key,
    this.leading,
    required this.title,
    this.action,
    this.isSettingsPage = false, // Default adalah false
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      leading: leading,
      actions: [
        if (isSettingsPage) // Menampilkan tombol logout jika halaman adalah pengaturan
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Tambahkan logika logout di sini
              Navigator.of(context).pushNamed('/login'); // Contoh navigasi ke halaman login
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
