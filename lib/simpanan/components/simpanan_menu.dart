import 'package:flutter/material.dart';
import 'package:mpay_godong/simpanan/penarikan/penarikan_screen.dart';
import 'package:mpay_godong/simpanan/saldo/saldo_screen.dart';
import 'package:mpay_godong/simpanan/setoran/setoran_screen.dart';

class SimpananMenu extends StatelessWidget {
  const SimpananMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Tambahkan SingleChildScrollView di sini
      child: Padding(
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
          _buildSummaryText(context, 'Transaksi : 0', FontWeight.bold),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _buildSummaryText(context, 'Setoran : Rp.0'),
                const SizedBox(height: 8),
                _buildSummaryText(context, 'Penarikan : Rp.0'),
              ],
            ),
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
      physics: const NeverScrollableScrollPhysics(), // Non-aktifkan scroll GridView agar SingleChildScrollView yang menangani scroll
      crossAxisCount: 2,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      children: <Widget>[
        _buildMenuButton(
          context,
          label: 'SETORAN',
          icon: Image.asset(
            'assets/images/setoran.png',
            height: 90,
          ),
          color: Colors.white,
          onPressed: () =>
              Navigator.pushNamed(context, SetoranScreen.routeName),
        ),
        _buildMenuButton(
          context,
          label: 'PENARIKAN',
          icon: Image.asset(
            'assets/images/penarikan.png',
            height: 90,
          ),
          color: Colors.white,
          onPressed: () =>
              Navigator.pushNamed(context, PenarikanScreen.routeName),
        ),
        _buildMenuButton(
          context,
          label: 'CEK SALDO',
          icon: Image.asset(
            'assets/images/ceksaldo.png',
            height: 90,
          ),
          color: Colors.white,
          onPressed: () =>
              Navigator.pushNamed(context, SaldoScreen.routeName),
        ),
        _buildMenuButton(
          context,
          label: 'REPRINT',
          icon: Image.asset(
            'assets/images/printer.png',
            height: 90,
          ),
          color: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/reprint'),
        ),
      ],
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required String label,
        dynamic icon,
        required Color color,
        required Function() onPressed}) {
    // Mendapatkan ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;

    // Mengatur ukuran padding dan icon berdasarkan lebar layar
    final buttonPadding = screenWidth * 0.04; // Misalnya 4% dari lebar layar
    final iconSize = screenWidth * 0.1; // Misalnya 10% dari lebar layar

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
