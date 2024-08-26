import 'package:flutter/material.dart';

class LaporanMenu extends StatefulWidget {
  const LaporanMenu({super.key});

  @override
  State<LaporanMenu> createState() => _LaporanMenuState();
}

class _LaporanMenuState extends State<LaporanMenu> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Bagian Laporan
          const Row(
            children: [
              Expanded(
                child: Text(
                  "SETORAN",
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
              ),
              Expanded(
                child: Text(":"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(
                child: Text(
                  "PENARIKAN",
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
              ),
              Expanded(
                child: Text(":"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(
                child: Text(
                  "TOTAL",
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
              ),
              Expanded(
                child: Text(":"),
              ),
            ],
          ),
          const SizedBox(height: 20),

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
        ],
      ),
    );
  }
}
