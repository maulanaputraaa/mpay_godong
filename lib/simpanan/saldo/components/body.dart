import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'saldo_menu.dart';

// Model Nasabah
class Nasabah {
  final String nama;
  final String alamat;
  final String rekening;
  final String saldo;

  Nasabah({
    required this.nama,
    required this.alamat,
    required this.rekening,
    required this.saldo,
  });

  factory Nasabah.fromJson(Map<String, dynamic> json) {
    return Nasabah(
      nama: json['nasabah']?['Nama'] ?? 'Tidak Ditemukan',
      alamat: json['nasabah']?['Alamat'] ?? 'Tidak Ditemukan',
      rekening: json['Rekening'] ?? 'Tidak Ditemukan',
      saldo: json['SaldoAkhir']?.toString() ?? 'Tidak Ditemukan',
    );
  }
}

// Fetch suggestion data for Nasabah
Future<List<Nasabah>> fetchNasabahSuggestions(String query) async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'auth_token');
  final url = 'https://godong.niznet.my.id/api/tabungan?page=1&per_page=10&search=$query';

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> parsedResponse = json.decode(response.body);
    List<dynamic> data = parsedResponse['data'];

    return data.map((json) => Nasabah.fromJson(json)).toList();
  } else {
    print('Failed to load nasabah. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    return [];
  }
}

class SaldoBody extends StatefulWidget {
  const SaldoBody({super.key});

  @override
  State<SaldoBody> createState() => _SaldoBodyState();
}

class _SaldoBodyState extends State<SaldoBody> {
  final TextEditingController _rekeningController = TextEditingController();
  String? namaNasabah;
  String? alamatNasabah;
  String? rekeningNasabah;
  String? saldoNasabah;
  String lastSelectedRekening = '';

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _rekeningController.addListener(_onRekeningChanged);
  }

  @override
  void dispose() {
    _rekeningController.removeListener(_onRekeningChanged);
    _rekeningController.dispose();
    super.dispose();
  }

  void _onRekeningChanged() {
    if (_rekeningController.text != lastSelectedRekening) {
      setState(() {
        namaNasabah = null;
        alamatNasabah = null;
        rekeningNasabah = null;
        saldoNasabah = null;
      });
    }
  }

  Future<void> fetchNasabahData(String rekening) async {
    if (rekening.isEmpty) {
      setState(() {
        namaNasabah = null;
        alamatNasabah = null;
        rekeningNasabah = null;
        saldoNasabah = null;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    List<Nasabah> suggestions = await fetchNasabahSuggestions(rekening);

    if (suggestions.isNotEmpty) {
      Nasabah selectedNasabah = suggestions.first;
      setState(() {
        namaNasabah = selectedNasabah.nama;
        alamatNasabah = selectedNasabah.alamat;
        rekeningNasabah = selectedNasabah.rekening;
        saldoNasabah = selectedNasabah.saldo;
        lastSelectedRekening = selectedNasabah.rekening;
      });
    } else {
      setState(() {
        namaNasabah = 'Tidak Ditemukan';
        alamatNasabah = 'Tidak Ditemukan';
        rekeningNasabah = 'Tidak Ditemukan';
        saldoNasabah = 'Tidak Ditemukan';
        lastSelectedRekening = '';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  String formatRupiah(String saldo) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
    try {
      double saldoValue = double.parse(saldo);
      return formatter.format(saldoValue);
    } catch (e) {
      return saldo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SaldoMenu(),
          const SizedBox(height: 24),
          _buildAutocompleteInput(),
          const SizedBox(height: 24),
          _buildInfoBox('Nama Nasabah', namaNasabah ?? 'Belum Ada Data'),
          const SizedBox(height: 8),
          _buildInfoBox('Alamat Nasabah', alamatNasabah ?? 'Belum Ada Data'),
          const SizedBox(height: 8),
          _buildInfoBox('Rekening Nasabah', rekeningNasabah ?? 'Belum Ada Data'),
          const SizedBox(height: 8),
          _buildInfoBox('Saldo Akhir', saldoNasabah ?? 'Belum Ada Data', isSaldo: true),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: (_rekeningController.text.isNotEmpty && _rekeningController.text == lastSelectedRekening)
                ? () => fetchNasabahData(_rekeningController.text)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('CETAK', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
          if (isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildAutocompleteInput() {
    return Autocomplete<Nasabah>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Nasabah>.empty();
        }
        return fetchNasabahSuggestions(textEditingValue.text);
      },
      displayStringForOption: (Nasabah option) => option.rekening,
      onSelected: (Nasabah selectedNasabah) {
        setState(() {
          _rekeningController.text = selectedNasabah.rekening;
          namaNasabah = selectedNasabah.nama;
          alamatNasabah = selectedNasabah.alamat;
          rekeningNasabah = selectedNasabah.rekening;
          saldoNasabah = selectedNasabah.saldo;
          lastSelectedRekening = selectedNasabah.rekening;
        });
      },
      fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: fieldTextEditingController,
            focusNode: fieldFocusNode,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Rekening',
              labelStyle: TextStyle(color: Colors.grey[600]),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (value) {
              _rekeningController.text = value;
            },
          ),
        );
      },
      optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<Nasabah> onSelected, Iterable<Nasabah> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            elevation: 4.0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: options.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  final Nasabah option = options.elementAt(index);

                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.account_circle, color: Colors.green),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              '${option.rekening} - ${option.nama}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoBox(String title, String value, {bool isSaldo = false}) {
    String displayValue = isSaldo ? formatRupiah(value) : value;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.green),
          ),
          const SizedBox(height: 4),
          Text(
            displayValue,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
