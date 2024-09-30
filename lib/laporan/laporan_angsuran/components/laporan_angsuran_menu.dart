import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../models/mutasi_angsuran.dart';

class LaporanMenu extends StatefulWidget {
  const LaporanMenu({super.key});

  @override
  State<LaporanMenu> createState() => _LaporanMenuState();
}

class _LaporanMenuState extends State<LaporanMenu> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  late Future<Map<String, dynamic>> _reportFuture;
  List<AngsuranRequest> _allTransactions = [];
  List<AngsuranRequest> _filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    _fetchReportData();
  }

  Future<void> _fetchReportData() async {
    setState(() {
      _reportFuture = _fetchReportSummary();
    });
  }

  Future<Map<String, dynamic>> _fetchReportSummary() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token'); // Mengambil token

    const url = 'https://godong.niznet.my.id/api/angsuran?per_page=-1';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;

      double totalPokok = 0.0;
      double totalBunga = 0.0;
      double totalDenda = 0.0;

      for (var item in data) {
        final angsuran = AngsuranRequest.fromJson(item as Map<String, dynamic>);
        totalPokok += angsuran.dpokok;
        totalBunga += angsuran.dbunga;
        totalDenda += angsuran.denda;
      }

      final total = totalPokok + totalBunga + totalDenda;

      return {
        'pokok': totalPokok,
        'bunga': totalBunga,
        'denda': totalDenda,
        'total': total,
      };
    } else {
      print('Gagal memuat data laporan. Kode status: ${response.statusCode}');
      print('Isi respons: ${response.body}');
      throw Exception('Failed to load report summary');
    }
  }

  Future<void> _fetchTransactions() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token'); // Mengambil token

    const url = 'https://godong.niznet.my.id/api/angsuran';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final data = jsonResponse['data'] as List<dynamic>;
      _allTransactions = data.map((item) => AngsuranRequest.fromJson(item as Map<String, dynamic>)).toList();
      _filterTransactions();
    } else {
      print('Gagal memuat data transaksi. Kode status: ${response.statusCode}');
      print('Isi respons: ${response.body}');
      throw Exception('Failed to load transactions');
    }
  }

  void _filterTransactions() {
    if (_selectedStartDate != null && _selectedEndDate != null) {
      setState(() {
        _filteredTransactions = _allTransactions.where((transaction) {
          return transaction.tgl.isAfter(_selectedStartDate!.subtract(const Duration(days: 1))) &&
              transaction.tgl.isBefore(_selectedEndDate!.add(const Duration(days: 1)));
        }).toList();
      });
    } else {
      setState(() {
        _filteredTransactions = _allTransactions;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != (isStart ? _selectedStartDate : _selectedEndDate)) {
      setState(() {
        if (isStart) {
          _selectedStartDate = pickedDate;
        } else {
          _selectedEndDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FutureBuilder<Map<String, dynamic>>(
            future: _reportFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final data = snapshot.data!;
                return Column(
                  children: [
                    _buildReportRow("POKOK", data['pokok']),
                    const SizedBox(height: 10),
                    _buildReportRow("BUNGA", data['bunga']),
                    const SizedBox(height: 10),
                    _buildReportRow("DENDA", data['denda']),
                    const SizedBox(height: 10),
                    _buildReportRow("TOTAL", data['total']),
                  ],
                );
              } else {
                return const Text('No data available');
              }
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      _selectedStartDate != null ? _selectedStartDate.toString().split(' ')[0] : 'Tanggal Mulai',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      _selectedEndDate != null ? _selectedEndDate.toString().split(' ')[0] : 'Sampai Tanggal',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_selectedStartDate != null && _selectedEndDate != null) {
                await _fetchTransactions();
                _filterTransactions();
              } else {
                // Tampilkan pesan error jika tanggal tidak dipilih
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Silakan pilih tanggal mulai dan sampai')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            child: const Text("PREVIEW", style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _filteredTransactions.isEmpty
                ? const Center(child: Text('Tidak ada transaksi untuk tanggal yang dipilih'))
                : ListView.builder(
              itemCount: _filteredTransactions.length,
              itemBuilder: (context, index) {
                final transaction = _filteredTransactions[index];
                return ListTile(
                  title: Text('Tanggal: ${DateFormat('yyyy-MM-dd').format(transaction.tgl)}'),
                  subtitle: Text('Pokok: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(transaction.dpokok)}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportRow(String label, double value) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.green, fontSize: 18),
          ),
        ),
        Expanded(
          child: Text(
            currencyFormat.format(value),
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
