import 'package:flutter/material.dart';
import 'package:mpay_godong/layouts/top_bar.dart';

class SetoranScreen extends StatelessWidget {
  static const String routeName = '/simpanan/setoran';
  const SetoranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(title: Text('Setoran')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconButton(Icons.person_search, Colors.blue),
                  _buildIconButton(Icons.qr_code_scanner, Colors.indigo),
                ],
              ),
              const SizedBox(height: 24),
              _buildInputField('Rekening'),
              const SizedBox(height: 16),
              _buildInputField('Nominal'),
              const SizedBox(height: 16),
              _buildInputField('Keterangan', initialValue: 'SETOR TUNAI'),
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
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: IconButton(
        icon: Icon(icon, size: 40, color: color),
        onPressed: () {},
      ),
    );
  }

  Widget _buildInputField(String label, {String? initialValue}) {
    return TextField(
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
