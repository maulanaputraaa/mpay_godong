import 'package:flutter/material.dart';

class PengaturanMenu extends StatefulWidget {
  const PengaturanMenu({super.key});

  @override
  _PengaturanMenuState createState() => _PengaturanMenuState();
}

class _PengaturanMenuState extends State<PengaturanMenu> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTransactionSummary(context),
          const SizedBox(height: 30),
          _buildMenuTitle(context),
          const SizedBox(height: 20),
          _buildMenuGrid(context),
        ],
      ),
    );
  }

  Widget _buildTransactionSummary(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.9,
        minWidth: 100,
      ),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildSummaryText(context, 'Informasi Pengaturan', FontWeight.bold),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryText(BuildContext context, String text,
      [FontWeight? weight]) {
    return Text(
      text,
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.035,
        fontWeight: weight ?? FontWeight.normal,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildMenuTitle(BuildContext context) {
    return Text(
      'Menu Pengaturan',
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.05,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      children: <Widget>[
        _buildMenuButton(
          context,
          label: 'TES PRINTER',
          icon: Image.asset(
            'assets/images/printer.png',
            height: 90,
          ),
          color: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/tes printer'),
        ),
        _buildMenuButton(
          context,
          label: 'SET IP/PRINTER',
          icon: Image.asset(
            'assets/images/ip.png',
            height: 90,
          ),
          color: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/set ip'),
        ),
        _buildMenuButton(
          context,
          label: 'BACKUP',
          icon: Image.asset(
            'assets/images/backup.png',
            height: 90,
          ),
          color: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/backup'),
        ),
        _buildMenuButton(
          context,
          label: 'GANTI PASSWORD',
          icon: Image.asset(
            'assets/images/password.png',
            height: 90,
          ),
          color: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/password'),
        ),
      ],
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required String label,
        dynamic icon,
        required Color color,
        required Function() onPressed}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonPadding = screenWidth * 0.04;
    final iconSize = screenWidth * 0.1;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black87,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(buttonPadding),
        elevation: 4,
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon is Image ? icon : Icon(icon, size: iconSize),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
