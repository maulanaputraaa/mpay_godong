import 'package:flutter/material.dart';
import 'package:mac_address/mac_address.dart';

class PengaturanMenu extends StatefulWidget {
  const PengaturanMenu({super.key});

  @override
  _PengaturanMenuState createState() => _PengaturanMenuState();
}

class _PengaturanMenuState extends State<PengaturanMenu> {
  String macAddress = "Memuat...";

  @override
  void initState() {
    super.initState();
    _getMacAddress();
  }

  Future<void> _getMacAddress() async {
    try {
      // Mendapatkan MAC address menggunakan library mac_address
      String? result = await GetMac.macAddress;
      setState(() {
        macAddress = result;
      });
        } catch (e) {
      setState(() {
        macAddress = "Gagal mendapatkan MAC Address";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              _buildSummaryText(context, 'MAC Address: $macAddress', FontWeight.bold),
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
      'Menu Tabungan',
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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black87,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        elevation: 4,
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon is Image ? icon : Icon(icon, size: 40),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
