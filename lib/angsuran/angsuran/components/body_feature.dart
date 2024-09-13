import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../models/angsuran_debitur.dart';
import 'angsuran_feature_menu.dart';

Future<List<Debitur>> fetchDebiturSuggestions(String query) async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'auth_token');
  final url = 'https://godong.niznet.my.id/api/debitur?page=1&per_page=10&search=$query';

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  print('Isi respons: ${response.body}');
  if (response.statusCode == 200) {
    Map<String, dynamic> parsedResponse = json.decode(response.body);
    List<dynamic> data = parsedResponse['data'];

    return data.map((json) => Debitur.fromJson(json)).toList();
  } else {
    print('Gagal memuat debitur. Kode status: ${response.statusCode}');
    print('Isi respons: ${response.body}');
    return [];
  }
}

class BodyFeature extends StatefulWidget {
  const BodyFeature({Key? key}) : super(key: key);

  @override
  State<BodyFeature> createState() => _BodyFeatureState();
}

class _BodyFeatureState extends State<BodyFeature> {
  final TextEditingController _rekeningController = TextEditingController();
  final TextEditingController _pokokController = TextEditingController();
  final TextEditingController _jasaController = TextEditingController();
  final TextEditingController _dendaController = TextEditingController();
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  String? namaDebitur;
  String? bakiDebet;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _pokokController.addListener(_formatCurrency);
    _jasaController.addListener(_formatCurrency);
    _dendaController.addListener(_formatCurrency);
  }

  @override
  void dispose() {
    _rekeningController.dispose();
    _pokokController.removeListener(_formatCurrency);
    _pokokController.dispose();
    _jasaController.removeListener(_formatCurrency);
    _jasaController.dispose();
    _dendaController.removeListener(_formatCurrency);
    _dendaController.dispose();
    super.dispose();
  }

  void _formatCurrency() {
    [_pokokController, _jasaController, _dendaController].forEach((controller) {
      String text = controller.text.replaceAll(RegExp(r'[^0-9]'), '');
      if (text.isNotEmpty) {
        String formatted = _currencyFormat.format(int.parse(text));
        controller.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    });
  }

  String generateTransactionCode() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    final random = Random();
    return List.generate(3, (index) => characters[random.nextInt(characters.length)]).join();
  }

  Future<void> _processAngsuran() async {
    if (_rekeningController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Rekening harus diisi',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (_pokokController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Debet Pokok harus diisi',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (_jasaController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Kredit Bunga harus diisi',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (_dendaController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Denda harus diisi',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');
      print('Token: $token'); // Tambahkan log token untuk debug

      const url = 'https://godong.niznet.my.id/api/angsuran';
      print('URL: $url'); // Tambahkan log URL untuk debug

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "ID": null,
          "CabangEntry": "001",
          "Status": "1",
          "Faktur": generateTransactionCode(),
          "Tgl": DateFormat('yyyy-MM-dd').format(DateTime.now()),
          "Rekening": _rekeningController.text,
          "Keterangan": "SETORAN",
          "DPokok": double.parse(_pokokController.text.replaceAll(RegExp(r'[^\d]'), '')),
          "KPokok": double.parse(_pokokController.text.replaceAll(RegExp(r'[^\d]'), '')),
          "DBunga": double.parse(_jasaController.text.replaceAll(RegExp(r'[^\d]'), '')),
          "KBunga": double.parse(_jasaController.text.replaceAll(RegExp(r'[^\d]'), '')),
          "Denda": double.parse(_dendaController.text.replaceAll(RegExp(r'[^\d]'), '')),
          "Administrasi": 0,
          "Kas": "K",
          "DateTime": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          "UserName": "" // Ganti dengan username jika diperlukan
        }),
      );


      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: 'Angsuran berhasil diproses!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        setState(() {
          _rekeningController.clear();
          _pokokController.clear();
          _jasaController.clear();
          _dendaController.clear();
          namaDebitur = null;
          bakiDebet = null;
        });
      } else {
        Fluttertoast.showToast(
          msg: 'Gagal memproses angsuran.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Terjadi kesalahan: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
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
            const AngsuranFeatureMenu(),
            const SizedBox(height: 24),
            _buildAutocompleteInput(),
            const SizedBox(height: 16),
            _buildTextField('Pokok', _pokokController),
            const SizedBox(height: 16),
            _buildTextField('Jasa', _jasaController),
            const SizedBox(height: 16),
            _buildTextField('Denda', _dendaController),
            const SizedBox(height: 24),
            _buildInfoBox('Nama Debitur', namaDebitur ?? 'Belum Ada Data'),
            const SizedBox(height: 8),
            _buildInfoBox('Baki Debet', bakiDebet ?? 'Belum Ada Data'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: isLoading ? null : _processAngsuran,
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
    return Autocomplete<Debitur>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Debitur>.empty();
        }
        return fetchDebiturSuggestions(textEditingValue.text);
      },
      displayStringForOption: (Debitur option) => option.rekening,
      onSelected: (Debitur selectedDebitur) {
        setState(() {
          _rekeningController.text = selectedDebitur.rekening;
          namaDebitur = selectedDebitur.nasabah.nama;
          bakiDebet = _currencyFormat.format(selectedDebitur.pokok);
          _pokokController.text = _currencyFormat.format(selectedDebitur.pokok);
          _jasaController.text = _currencyFormat.format(selectedDebitur.jasa);
          _dendaController.text = _currencyFormat.format(selectedDebitur.denda);
        });
      },
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          decoration: InputDecoration(
            hintText: 'Masukkan nomor rekening',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, Iterable<Debitur> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options.elementAt(index);
                return ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text(option.rekening),
                  onTap: () => onSelected(option),
                );
              },
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
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildInfoBox(String title, String info) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
          Text(info, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
