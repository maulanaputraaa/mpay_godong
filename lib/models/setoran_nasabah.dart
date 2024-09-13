class Nasabah {
  final String nama;
  final String alamat;
  final String rekening;
  final String saldo;

  Nasabah({
    required this.nama,
    required this.alamat,
    required this.rekening,
    required this.saldo,
  });

  factory Nasabah.fromJson(Map<String, dynamic> json) {
    return Nasabah(
      nama: json['nasabah']?['Nama'] ?? 'Tidak Ditemukan',
      alamat: json['nasabah']?['Alamat'] ?? 'Tidak Ditemukan',
      rekening: json['Rekening'] ?? 'Tidak Ditemukan',
      saldo: json['SaldoAkhir']?.toString() ?? 'Tidak Ditemukan',
    );
  }
}