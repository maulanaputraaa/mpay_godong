import 'package:mpay_godong/models/main_nasabah.dart';

class Debitur {
  final String rekening;
  final String saldoPokok;
  final double pokok;
  final double jasa;
  final double denda;
  final Nasabah nasabah;

  Debitur({
    required this.rekening,
    required this.saldoPokok,
    required this.pokok,
    required this.jasa,
    required this.denda,
    required this.nasabah
  });

  factory Debitur.fromJson(Map<String, dynamic> json) {
    return Debitur(
      rekening: json['Rekening'] ?? 'Tidak Ditemukan',
      saldoPokok: json['SaldoPokok']?.toString() ?? 'Tidak Ditemukan',
      pokok: json['Pokok']?.toDouble() ?? 0.0,
      jasa: json['Jasa']?.toDouble() ?? 0.0,
      denda: json['Denda']?.toDouble() ?? 0.0,
      nasabah: Nasabah.fromJson(json['nasabah'])
    );
  }
}