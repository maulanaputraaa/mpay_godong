import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mpay_godong/simpanan/penarikan/components/penarikan_menu.dart';

class PenarikanBody extends StatefulWidget {
  const PenarikanBody({super.key});

  @override
  State<PenarikanBody> createState() => _BodyState();
}

class _BodyState extends State<PenarikanBody> {
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const PenarikanMenu(),
          const SizedBox(height: 24),
          _buildInputField('Rekening'),
          const SizedBox(height: 16),
          _buildInputField('Nominal', controller: _nominalController),
          const SizedBox(height: 16),
          _buildInputField('Keterangan', initialValue: 'TARIK TUNAI'),
          const SizedBox(height: 24),
          const Text(
            'Nama Nasabah',
            style: TextStyle(fontSize: 16, color: Colors.green),
          ),
          const SizedBox(height: 8),
          const Text(
            'Saldo Akhir',
            style: TextStyle(fontSize: 16, color: Colors.green),
          ),
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

  Widget _buildInputField(String label, {TextEditingController? controller, String? initialValue}) {
    return TextField(
      controller: controller ?? (initialValue != null ? TextEditingController(text: initialValue) : null),
      keyboardType: label == 'Nominal' ? TextInputType.number : TextInputType.text,
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
}
