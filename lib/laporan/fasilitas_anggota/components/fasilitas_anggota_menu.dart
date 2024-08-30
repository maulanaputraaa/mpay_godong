import 'package:flutter/material.dart';

import '../../../contact/contact_screen.dart';


class FasilitasAnggotaMenu extends StatelessWidget {
  const FasilitasAnggotaMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildIconButton(
          Icons.person_search,
          Colors.blue,
          onPressed: () {
            Navigator.pushNamed(context, ContactScreen.routeName);
          },
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, Color color, {required VoidCallback onPressed}) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: IconButton(
        icon: Icon(icon, size: 40, color: color),
        onPressed: onPressed,
      ),
    );
  }
}
