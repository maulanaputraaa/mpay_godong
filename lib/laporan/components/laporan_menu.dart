import 'package:flutter/material.dart';
import 'package:mpay_godong/laporan/fasilitas_anggota/fasilitas_anggota_screen.dart';
import 'package:mpay_godong/laporan/laporan_angsuran/laporan_angsuran_screen.dart';
import 'package:mpay_godong/laporan/laporan_simpanan/laporan_simpanan_screen.dart';
import 'package:mpay_godong/laporan/rekap_laporan/rekap_laporan_screen.dart';

class LaporanMenu extends StatelessWidget {
  const LaporanMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildSummaryText(context, 'Mutasi Tab : 0', FontWeight.bold),
              const SizedBox(height: 8),
              _buildSummaryText(context, 'Angsuran : 0', FontWeight.bold),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _buildSummaryText(context, 'Total Uang : Rp.0'),
                const SizedBox(height: 8),
                _buildSummaryText(context, 'Total Angsuran : Rp.0'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryText(BuildContext context, String text, [FontWeight? weight]) {
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
      'Menu Laporan',
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
          label: 'SIMPANAN',
          icon: Image.asset(
            'assets/images/simpanan.png',
            height: 90,
          ),
          color: Colors.white,
          onPressed: () =>
              Navigator.pushNamed(context, LaporanSimpananScreen.routeName),
        ),
        _buildMenuButton(
          context,
          label: 'PINJAMAN',
          icon: Image.asset(
            'assets/images/pinjaman.png',
            height: 90,
          ),
          color: Colors.white,
          onPressed: () => Navigator.pushNamed(context, LaporanAngsuranScreen.routeName),
        ),
        _buildMenuButton(
          context,
          label: 'REKAP',
          icon: Image.asset(
            'assets/images/rekap.png',
            height: 90,
          ),
          color: Colors.white,
          onPressed: () => Navigator.pushNamed(context, RekapLaporanScreen.routeName),
        ),
        _buildMenuButton(
          context,
          label: 'CEK FASILITAS ANGGOTA',
          icon: Image.asset(
            'assets/images/cek.png',
            height: 80,
          ),
          color: Colors.white,
          onPressed: () => Navigator.pushNamed(context, FasilitasAnggotaScreen.routeName),
        ),
      ],
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required String label, dynamic icon, required Color color, required Function() onPressed}) {
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
