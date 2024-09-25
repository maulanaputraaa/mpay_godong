import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:mpay_godong/laporan/fasilitas_anggota/fasilitas_anggota_screen.dart';
import 'package:mpay_godong/laporan/laporan_angsuran/laporan_angsuran_screen.dart';
import 'package:mpay_godong/laporan/laporan_simpanan/laporan_simpanan_screen.dart';
import 'package:mpay_godong/laporan/rekap_laporan/rekap_laporan_screen.dart';
import '../../models/mutasi_angsuran.dart';
import '../../models/mutasi_nasabah.dart';

class LaporanMenu extends StatefulWidget {
  const LaporanMenu({Key? key}) : super(key: key);

  @override
  _LaporanMenuState createState() => _LaporanMenuState();
}

class _LaporanMenuState extends State<LaporanMenu> {
  int mutasiTabCount = 0;
  int angsuranCount = 0;
  double totalUang = 0;
  double totalAngsuran = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');

    if (token == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      // Fetch mutasi tabungan data
      const mutasiUrl = 'https://godong.niznet.my.id/api/mutasi-tabungan?per_page=-1';
      final mutasiResponse = await http.get(
        Uri.parse(mutasiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Cetak respon mutasi untuk debugging
      print(mutasiResponse.body);

      if (mutasiResponse.statusCode == 200) {
        // Pastikan kita menangani response sebagai list
        final List<dynamic> mutasiData = json.decode(mutasiResponse.body);

        // Debugging: cetak data yang diterima
        print('Mutasi Data: $mutasiData');

        // Parsing ke dalam objek MutasiTabungan
        final List<MutasiTabungan> mutasiList = mutasiData.map((json) {
          print('Parsing JSON: $json'); // Tambahkan ini
          return MutasiTabungan.fromJson(json);
        }).toList();

        setState(() {
          mutasiTabCount = mutasiList.length;
          totalUang = mutasiList.fold(0.0, (sum, item) => sum + (item.dk == 'K' ? item.jumlah : 0));
        });
      } else {
        print('Failed to fetch mutasi tabungan data. Status code: ${mutasiResponse.statusCode}');
      }

      // Fetch angsuran data
      const angsuranUrl = 'https://godong.niznet.my.id/api/angsuran?per_page=-1';
      final angsuranResponse = await http.get(
        Uri.parse(angsuranUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

// Cetak respon angsuran untuk debugging
      print(angsuranResponse.body);

      if (angsuranResponse.statusCode == 200) {
        final List<dynamic> angsuranData = json.decode(angsuranResponse.body);
        final List<AngsuranRequest> angsuranList = angsuranData.map((json) {
          return AngsuranRequest.fromJson(json); // Pastikan Anda memiliki konstruktor dariJson yang benar
        }).toList();

        setState(() {
          angsuranCount = angsuranList.length;
          totalAngsuran = angsuranList.fold(0.0, (sum, item) => sum + item.dpokok + item.dbunga + item.denda);
        });
      } else {
        print('Failed to fetch angsuran data. Status code: ${angsuranResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e'); // Ini akan menangkap error
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildSummaryText(context, 'Mutasi Tab : $mutasiTabCount', FontWeight.bold),
              const SizedBox(height: 8),
              _buildSummaryText(context, 'Angsuran : $angsuranCount', FontWeight.bold),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _buildSummaryText(context, 'Total Uang : Rp.${NumberFormat('#,##0').format(totalUang)}'),
                const SizedBox(height: 8),
                _buildSummaryText(context, 'Total Angsuran : Rp.${NumberFormat('#,##0').format(totalAngsuran)}'),
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
