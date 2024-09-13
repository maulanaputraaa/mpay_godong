import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../models/tabungan_nasabah.dart';

// Ambil data dari API dengan token JWT
Future<List<Nasabah>> fetchNasabah({int page = 1}) async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'auth_token');
  final url = 'https://godong.niznet.my.id/api/tabungan?page=$page';

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('Response body: ${response.body}');
    Map<String, dynamic> parsedResponse = json.decode(response.body);

    List<dynamic> data = parsedResponse['data'];
    List<Nasabah> nasabahList = data.map((json) => Nasabah.fromJson(json)).toList();

    String? nextPageUrl = parsedResponse['next_page_url'];
    if (nextPageUrl != null) {
      nasabahList.addAll(await fetchNasabah(page: page + 1));
    }

    return nasabahList;
  } else {
    print('Failed to load nasabah. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to load nasabah');
  }
}

// Widget item menu nasabah
class NasabahMenuItem extends StatelessWidget {
  final String name;
  final String rekening;
  final String kode;
  final VoidCallback onTap; // Tambahkan onTap callback

  const NasabahMenuItem({
    super.key,
    required this.name,
    required this.rekening,
    required this.kode,
    required this.onTap, // Tambahkan required onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Tambahkan fungsi yang dipanggil saat ditekan
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.person, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rekening: $rekening',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kode: $kode',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget menu nasabah
class NasabahMenu extends StatelessWidget {
  const NasabahMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Nasabah>>(
      future: fetchNasabah(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final nasabahs = snapshot.data!;

          if (nasabahs.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada data nasabah yang tersedia.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return Column(
            children: nasabahs.map((nasabah) {
              return NasabahMenuItem(
                name: nasabah.namaNasabah,
                rekening: nasabah.rekening,
                kode: nasabah.kode,
                onTap: () {
                  // Aksi ketika item ditekan, misalnya navigasi ke halaman detail
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailNasabahPage(nasabah: nasabah),
                    ),
                  );
                },
              );
            }).toList(),
          );
        } else {
          return const Center(child: Text('No nasabah available'));
        }
      },
    );
  }
}

// Contoh halaman detail nasabah
class DetailNasabahPage extends StatelessWidget {
  final Nasabah nasabah;

  const DetailNasabahPage({super.key, required this.nasabah});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Nasabah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nasabah.namaNasabah,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Rekening: ${nasabah.rekening}'),
            Text('Kode: ${nasabah.kode}'),
            Text('Saldo Akhir: ${nasabah.saldoAkhir}'),
            // Tambahkan informasi lain sesuai kebutuhan
          ],
        ),
      ),
    );
  }
}
