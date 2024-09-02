import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mpay_godong/simpanan/saldo/components/saldo_menu.dart';

class SaldoBody extends StatefulWidget {
  const SaldoBody({super.key});

  @override
  State<SaldoBody> createState() => _BodyState();
}

class _BodyState extends State<SaldoBody> {
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
          const SaldoMenu(),
          const SizedBox(height: 24),
          _buildInputField('Rekening'),
          const SizedBox(height: 24),
          _buildInfoBox('Nama Nasabah', 'John Doe'),
          const SizedBox(height: 8),
          _buildInfoBox('Alamat Nasabah', 'Jl. Mawar No. 123, Jakarta'),
          const SizedBox(height: 8),
          _buildInfoBox('Rekening Nasabah', '1234567890'),
          const SizedBox(height: 8),
          _buildInfoBox('Saldo Akhir', 'Rp 10.000.000'),
          const SizedBox(height: 32),
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
      keyboardType: label == 'Rekening' ? TextInputType.number : TextInputType.text,
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
            style: const TextStyle(fontSize: 14, color: Colors.grey),
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
