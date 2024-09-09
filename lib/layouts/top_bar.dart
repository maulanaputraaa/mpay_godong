import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../auth/auth_provider.dart';

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
            onPressed: () async {
              final success = await context.read<AuthProvider>().logout();
              if (success) {
                Fluttertoast.showToast(
                  msg: "Logout berhasil",
                  backgroundColor: Colors.green,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                );
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              } else {
                Fluttertoast.showToast(
                  msg: "Logout gagal, silakan coba lagi.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              }
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
