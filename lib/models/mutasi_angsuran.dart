import 'package:intl/intl.dart';

class AngsuranRequest {
  final String? cabangEntry;
  final String? status;
  final String faktur;
  final DateTime tgl;
  final String rekening;
  final String? keterangan;
  final double dpokok;
  final double kpokok;
  final double dbunga;
  final double kbunga;
  final double denda;
  final double administrasi;
  final String kas;
  final DateTime? dateTime;
  final String? userName;

  AngsuranRequest({
    this.cabangEntry,
    this.status,
    required this.faktur,
    required this.tgl,
    required this.rekening,
    this.keterangan,
    required this.dpokok,
    required this.kpokok,
    required this.dbunga,
    required this.kbunga,
    required this.denda,
    required this.administrasi,
    required this.kas,
    this.dateTime,
    this.userName,
  });

  factory AngsuranRequest.fromJson(Map<String, dynamic> json) {
    return AngsuranRequest(
      cabangEntry: json['CabangEntry'],
      status: json['Status'],
      faktur: json['Faktur'] ?? '',
      tgl: DateTime.parse(json['Tgl']),
      rekening: json['Rekening'] ?? '',
      keterangan: json['Keterangan'],
      dpokok: (json['DPokok'] ?? 0.0).toDouble(),
      kpokok: (json['KPokok'] ?? 0.0).toDouble(),
      dbunga: (json['DBunga'] ?? 0.0).toDouble(),
      kbunga: (json['KBunga'] ?? 0.0).toDouble(),
      denda: (json['Denda'] ?? 0.0).toDouble(),
      administrasi: (json['Administrasi'] ?? 0.0).toDouble(),
      kas: json['Kas'] ?? '',
      dateTime: json['DateTime'] != null ? DateTime.parse(json['DateTime']) : null,
      userName: json['UserName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CabangEntry': cabangEntry,
      'Status': status,
      'Faktur': faktur,
      'Tgl': DateFormat('yyyy-MM-dd').format(tgl),
      'Rekening': rekening,
      'Keterangan': keterangan,
      'DPokok': dpokok,
      'KPokok': kpokok,
      'DBunga': dbunga,
      'KBunga': kbunga,
      'Denda': denda,
      'Administrasi': administrasi,
      'Kas': kas,
      'DateTime': dateTime != null ? DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime!) : null,
      'UserName': userName,
    };
  }
}
