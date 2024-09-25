import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart'; // Tambahkan ini untuk format rupiah
import '../../../models/mutasi_angsuran.dart';
import '../../../models/mutasi_nasabah.dart';

// Model untuk Transaksi
class Transaksi {
  final DateTime tgl;
  final String jenis;
  final double jumlah;

  Transaksi({required this.tgl, required this.jenis, required this.jumlah});
}

class RekapLaporanMenu extends StatefulWidget {
  const RekapLaporanMenu({super.key});

  @override
  State<RekapLaporanMenu> createState() => _LaporanMenuState();
}

class _LaporanMenuState extends State<RekapLaporanMenu> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  int mutasiTabCount = 0;
  int angsuranCount = 0;
  double totalUang = 0;
  double totalAngsuran = 0;
  bool isLoading = true;

  List<MutasiTabungan> mutasiList = [];
  List<AngsuranRequest> angsuranList = [];
  List<Transaksi> transaksiList = []; // Daftar transaksi gabungan

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Fungsi untuk memilih tanggal
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

      if (mutasiResponse.statusCode == 200) {
        final List<dynamic> mutasiData = json.decode(mutasiResponse.body);
        mutasiList = mutasiData.map((json) => MutasiTabungan.fromJson(json)).toList();

        setState(() {
          mutasiTabCount = mutasiList.length;
          totalUang = mutasiList.fold(0.0, (sum, item) => sum + item.jumlah);

          // Tambahkan transaksi dari mutasi tabungan
          for (var mutasi in mutasiList) {
            String keteranganTransaksi = mutasi.dk == 'D' ? 'Setoran' : 'Penarikan';
            transaksiList.add(Transaksi(tgl: mutasi.tgl, jenis: keteranganTransaksi, jumlah: mutasi.jumlah));
          }
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

      if (angsuranResponse.statusCode == 200) {
        final List<dynamic> angsuranData = json.decode(angsuranResponse.body);
        angsuranList = angsuranData.map((json) => AngsuranRequest.fromJson(json)).toList();

        setState(() {
          angsuranCount = angsuranList.length;
          totalAngsuran = angsuranList.fold(0.0, (sum, item) => sum + item.dpokok + item.dbunga + item.denda);

          // Tambahkan transaksi dari angsuran
          for (var angsuran in angsuranList) {
            transaksiList.add(Transaksi(tgl: angsuran.tgl, jenis: 'Angsuran', jumlah: angsuran.dpokok + angsuran.dbunga + angsuran.denda));
          }
        });
      } else {
        print('Failed to fetch angsuran data. Status code: ${angsuranResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatRupiah(double amount) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 2);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Bagian Pemilihan Tanggal
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

          // Tombol Preview
          ElevatedButton(
            onPressed: () {
              // Logika untuk menampilkan laporan atau melakukan preview
              print("Preview laporan dengan tanggal mulai: $_selectedStartDate dan sampai tanggal: $_selectedEndDate");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            child: const Text("PREVIEW", style: TextStyle(fontSize: 18,color: Colors.white)),
          ),

          // Daftar Transaksi Gabungan
          const SizedBox(height: 20),
          const Text(
            'Daftar Transaksi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: transaksiList.length,
              itemBuilder: (context, index) {
                final transaksi = transaksiList[index];
                return ListTile(
                  title: Text('Tanggal: ${transaksi.tgl.toLocal().toString().split(' ')[0]}'),
                  subtitle: Text('Jumlah: ${formatRupiah(transaksi.jumlah)} - Jenis: ${transaksi.jenis}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
