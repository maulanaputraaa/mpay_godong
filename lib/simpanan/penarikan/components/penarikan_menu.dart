import 'package:flutter/material.dart';
import '../../../qr_scan/qr_scan_screen.dart';

class PenarikanMenu extends StatelessWidget {
  const PenarikanMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildIconButton(
          Icons.person_search,
          Colors.blue,
          onPressed: () {
          },
        ),
        _buildIconButton(
          Icons.qr_code_scanner,
          Colors.indigo,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QRScanScreen()),
            );
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
