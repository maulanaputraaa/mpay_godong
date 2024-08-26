import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'fasilitas_anggota_menu.dart';

class FasilitasAnggotaBody extends StatefulWidget {
  const FasilitasAnggotaBody({super.key});

  @override
  State<FasilitasAnggotaBody> createState() => _BodyState();
}

class _BodyState extends State<FasilitasAnggotaBody> {
  final TextEditingController _nominalController = TextEditingController();
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _nominalController.addListener(_formatNominal);
  }

  @override
  void dispose() {
    _nominalController.removeListener(_formatNominal);
    _nominalController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const FasilitasAnggotaMenu(),
          const SizedBox(height: 24),
          _buildInputField('Cif / Kode Register'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('PROSES', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, {String? initialValue}) {
    return TextField(
      keyboardType: label == 'Cif / Kode Register' ? TextInputType.number : TextInputType.text,
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
      controller: initialValue != null
          ? TextEditingController(text: initialValue)
          : null,
    );
  }
}
