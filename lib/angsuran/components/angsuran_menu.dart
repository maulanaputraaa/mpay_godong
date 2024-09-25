import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mpay_godong/angsuran/angsuran/angsuran_feature_screen.dart';
import 'package:mpay_godong/angsuran/tagihan/tagihan_screen.dart';
import '../../models/mutasi_angsuran.dart';

class AngsuranMenu extends StatefulWidget {
  const AngsuranMenu({super.key});

  @override
  _AngsuranMenuState createState() => _AngsuranMenuState();
}

class _AngsuranMenuState extends State<AngsuranMenu> {
  late Future<Map<String, dynamic>> _summaryFuture;

  @override
  void initState() {
    super.initState();
    _fetchAndUpdateSummary();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchAndUpdateSummary();
  }

  void _fetchAndUpdateSummary() {
    setState(() {
      _summaryFuture = fetchSummary();
    });
  }

  Future<Map<String, dynamic>> fetchSummary() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    const url = 'https://godong.niznet.my.id/api/angsuran?per_page=-1';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Isi respons: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;

      int transaksiTotal = 0;
      double total = 0.0;

      for (var item in data) {
        final angsuran = AngsuranRequest.fromJson(item as Map<String, dynamic>);
        transaksiTotal += 1;
        total += angsuran.kpokok + angsuran.kbunga + angsuran.administrasi + angsuran.denda;
      }

      return {
        'transaksi': transaksiTotal,
        'total': total,
      };
    } else {
      print('Gagal memuat ringkasan. Kode status: ${response.statusCode}');
      print('Isi respons: ${response.body}');
      throw Exception('Failed to load summary');
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
            FutureBuilder<Map<String, dynamic>>(
              future: _summaryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return _buildTransactionSummary(
                    context,
                    transaksi: data['transaksi'] as int,
                    total: data['total'] as double,
                  );
                } else {
                  return const Text('No data available');
                }
              },
            ),
            const SizedBox(height: 30),
            _buildMenuTitle(context),
            const SizedBox(height: 20),
            _buildMenuGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionSummary(BuildContext context,
      {required int transaksi, required double total}) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

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
          _buildSummaryText(context, 'Transaksi : $transaksi', FontWeight.bold),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _buildSummaryText(context, 'Total : ${currencyFormat.format(total)}'),
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
      'Menu Angsuran',
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
          label: 'ANGSURAN',
          icon: Image.asset(
            'assets/images/angsuran.png',
            height: 90,
          ),
          color: Colors.white,
          onPressed: () =>
              Navigator.pushNamed(context, AngsuranFeatureScreen.routeName).then((_) {
                _fetchAndUpdateSummary(); // Fetch summary again after navigating back
              }),
        ),
        _buildMenuButton(
          context,
          label: 'TAGIHAN',
          icon: Image.asset(
            'assets/images/tagihan.png',
            height: 90,
          ),
          color: Colors.white,
          onPressed: () =>
              Navigator.pushNamed(context, TagihanScreen.routeName).then((_) {
                _fetchAndUpdateSummary(); // Fetch summary again after navigating back
              }),
        ),
        _buildMenuButton(
          context,
          label: 'REPRINT',
          icon: Image.asset(
            'assets/images/printer.png',
            height: 90,
          ),
          color: Colors.white,
          onPressed: () =>
              Navigator.pushNamed(context, '/reprint').then((_) {
                _fetchAndUpdateSummary(); // Fetch summary again after navigating back
              }),
        ),
        _buildMenuButton(
          context,
          label: 'PENGAJUAN',
          icon: Image.asset(
            'assets/images/pengajuan.png',
            height: 90,
          ),
          color: Colors.white,
          onPressed: () =>
              Navigator.pushNamed(context, '/pengajuan').then((_) {
                _fetchAndUpdateSummary(); // Fetch summary again after navigating back
              }),
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
