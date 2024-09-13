class Nasabah {
  final String rekening;
  final String rekeningLama;
  final String tgl;
  final String kode;
  final String namaNasabah;
  final String golonganTabungan;
  final String statusBlokir;
  final double jumlahBlokir;
  final String tglPenutupan;
  final String keteranganBlokir;
  final double saldoAkhir;
  final String pekerjaan;
  final String userName;

  Nasabah({
    required this.rekening,
    required this.rekeningLama,
    required this.tgl,
    required this.kode,
    required this.namaNasabah,
    required this.golonganTabungan,
    required this.statusBlokir,
    required this.jumlahBlokir,
    required this.tglPenutupan,
    required this.keteranganBlokir,
    required this.saldoAkhir,
    required this.pekerjaan,
    required this.userName,
  });

  factory Nasabah.fromJson(Map<String, dynamic> json) {
    return Nasabah(
      rekening: json['Rekening'] ?? '',
      rekeningLama: json['RekeningLama'] ?? '',
      tgl: json['Tgl'] ?? '',
      kode: json['Kode'] ?? '',
      namaNasabah: json['NamaNasabah'] ?? '',
      golonganTabungan: json['GolonganTabungan'] ?? '',
      statusBlokir: json['StatusBlokir'] ?? '',
      jumlahBlokir: double.tryParse(json['JumlahBlokir']?.toString() ?? '0.0') ?? 0.0,
      tglPenutupan: json['TglPenutupan'] ?? '',
      keteranganBlokir: json['KeteranganBlokir'] ?? '',
      saldoAkhir: double.tryParse(json['SaldoAkhir']?.toString() ?? '0.0') ?? 0.0,
      pekerjaan: json['Pekerjaan'] ?? '',
      userName: json['UserName'] ?? '',
    );
  }
}
