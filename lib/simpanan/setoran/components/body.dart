import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../models/setoran_nasabah.dart';
import 'setoran_menu.dart';

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

class SetoranBody extends StatefulWidget {
  const SetoranBody({Key? key}) : super(key: key);

  @override
  State<SetoranBody> createState() => _SetoranBodyState();
}

class _SetoranBodyState extends State<SetoranBody> {
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
    _keteranganController.text = 'SETOR TUNAI';
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

  Future<void> _processSetoran() async {
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
          'DK': 'K',
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
          msg: 'Setoran berhasil diproses!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // Reset fields after succes
        setState(() {
          _rekeningController.clear();
          _nominalController.clear();
          _keteranganController.text = 'SETOR TUNAI';
          namaNasabah = null;
          saldoAkhir = null;
        });
      } else {
        Fluttertoast.showToast(
          msg: 'Gagal memproses setoran.',
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
            const SetoranMenu(),
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
              onPressed: isLoading ? null : _processSetoran,
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
            filled: true,
            fillColor: Colors.grey[200],
          ),
        );
      },
      optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<Nasabah> onSelected, Iterable<Nasabah> options) {
        final itemCount = options.length;
        final maxHeight = (itemCount > 0 ? (itemCount * 60.0) : 0.0).clamp(0.0, 300.0); // Ensure values are of type double

        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: maxHeight,
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: itemCount,
                itemBuilder: (BuildContext context, int index) {
                  final Nasabah option = options.elementAt(index);
                  return InkWell(
                    onTap: () {
                      onSelected(option);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.account_circle, color: Colors.green),
                          const SizedBox(width: 12),
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

  Widget _buildTextField(String label, TextEditingController controller, {FocusNode? focusNode}) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: label == 'Nominal' || label == 'Rekening' ? TextInputType.number : TextInputType.text,
      inputFormatters: label == 'Nominal' ? [FilteringTextInputFormatter.digitsOnly] : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  Widget _buildInfoBox(String title, String value) {
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
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
