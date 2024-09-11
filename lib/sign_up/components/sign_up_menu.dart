import 'package:flutter/material.dart';

class SignUpMenu extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _perusahaanController = TextEditingController();
  final TextEditingController _kodeperusahaanController = TextEditingController();
  final TextEditingController _kodeaccountController = TextEditingController();
  final TextEditingController _cabangController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignUpMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildTextField(_nameController, 'Nama Lengkap'),
          const SizedBox(height: 16),
          _buildTextField(_perusahaanController, 'Nama Perusahaan'),
          const SizedBox(height: 16),
          _buildTextField(_kodeperusahaanController, 'Kode Perusahaan'),
          const SizedBox(height: 16),
          _buildTextField(_kodeaccountController, 'Kode Account Officer'),
          const SizedBox(height: 16),
          _buildTextField(_cabangController, 'Cabang Entry'),
          const SizedBox(height: 16),
          _buildTextField(_usernameController, 'Username'),
          const SizedBox(height: 16),
          _buildTextField(_passwordController, 'Password', obscureText: true),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildActionButton('Save', Colors.green, () {
                // Handle save logic here
              }),
              _buildActionButton('Update', Colors.blue, () {
                // Handle update logic here
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: color, // Text color
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
