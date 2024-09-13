import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../models/penarikan_nasabah.dart';
import 'penarikan_menu.dart';

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
    print('Gagal memuat nasabah. Kode status: ${response.statusCode}');
    print('Isi respons: ${response.body}');
    return [];
  }
}

class PenarikanBody extends StatefulWidget {
  const PenarikanBody({Key? key}) : super(key: key);

  @override
  State<PenarikanBody> createState() => _PenarikanBodyState();
}

class _PenarikanBodyState extends State<PenarikanBody> {
  final TextEditingController _rekeningController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  String? namaNasabah;
  String? saldoAkhir;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nominalController.addListener(_formatNominal);
    _keteranganController.text = 'TARIK TUNAI';
  }

  @override
  void dispose() {
    _rekeningController.dispose();
    _nominalController.removeListener(_formatNominal);
    _nominalController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  void _formatNominal() {
    String text = _nominalController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.isNotEmpty) {
      String formatted = _currencyFormat.format(int.parse(text));
      _nominalController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  String generateTransactionCode() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    final random = Random();
    return List.generate(3, (index) => characters[random.nextInt(characters.length)]).join();
  }

  Future<void> _processPenarikan() async {
    setState(() {
      isLoading = true;
    });

    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      const url = 'https://godong.niznet.my.id/api/mutasi-tabungan';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'CabangEntry': '001',
          'Faktur': 'INV${DateTime.now().millisecondsSinceEpoch}',
          'Tgl': DateFormat('yyyy-MM-dd').format(DateTime.now()),
          'Rekening': _rekeningController.text,
          'KodeTransaksi': generateTransactionCode(),
          'DK': 'D',
          'Keterangan': _keteranganController.text,
          'Jumlah': double.parse(_nominalController.text.replaceAll(RegExp(r'[^\d]'), '')),
          'Debet': 0,
          'Kredit': 0,
          'UserName': '',
          'DateTime': DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()),
          'UserAcc': '',
          'Denda': 0,
        }),
      );

      if (response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: 'Penarikan berhasil diproses!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // Reset fields after success
        setState(() {
          _rekeningController.clear();
          _nominalController.clear();
          _keteranganController.text = 'TARIK TUNAI';
          namaNasabah = null;
          saldoAkhir = null;
        });
      } else {
        Fluttertoast.showToast(
          msg: 'Gagal memproses penarikan.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Terjadi kesalahan.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print('Error: $e');
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const PenarikanMenu(),
            const SizedBox(height: 24),
            _buildAutocompleteInput(),
            const SizedBox(height: 16),
            _buildTextField('Nominal', _nominalController),
            const SizedBox(height: 16),
            _buildTextField('Keterangan', _keteranganController),
            const SizedBox(height: 24),
            _buildInfoBox('Nama Nasabah', namaNasabah ?? 'Belum Ada Data'),
            const SizedBox(height: 8),
            _buildInfoBox('Saldo Akhir', saldoAkhir ?? 'Belum Ada Data'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: isLoading ? null : _processPenarikan,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('PROSES', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
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
          saldoAkhir = _currencyFormat.format(double.parse(selectedNasabah.saldo));
        });
      },
      fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
        return TextField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: 'Rekening',
            hintText: 'Masukkan nomor rekening',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
                          const Icon(Icons.person, color: Colors.green),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(option.rekening, style: const TextStyle(fontSize: 16)),
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.green)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
