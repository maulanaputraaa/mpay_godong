class MutasiTabungan {
  final String? cabangEntry;
  final String faktur;
  final DateTime tgl;
  final String rekening;
  final String? kodeTransaksi;
  final String dk;
  final String? keterangan;
  final double jumlah;
  final double debet;
  final double kredit;
  final String? userName;
  final DateTime? dateTime;
  final String? userAcc;
  final double? denda;

  MutasiTabungan({
    this.cabangEntry,
    required this.faktur,
    required this.tgl,
    required this.rekening,
    this.kodeTransaksi,
    required this.dk,
    this.keterangan,
    required this.jumlah,
    required this.debet,
    required this.kredit,
    this.userName,
    this.dateTime,
    this.userAcc,
    this.denda,
  });

  factory MutasiTabungan.fromJson(Map<String, dynamic> json) {
    return MutasiTabungan(
      cabangEntry: json['CabangEntry'],
      faktur: json['Faktur'] ?? '',
      tgl: DateTime.parse(json['Tgl']),
      rekening: json['Rekening'] ?? '',
      kodeTransaksi: json['KodeTransaksi'],
      dk: json['DK'] ?? '',
      keterangan: json['Keterangan'],
      jumlah: (json['Jumlah'] ?? 0.0).toDouble(),
      debet: (json['Debet'] ?? 0.0).toDouble(),
      kredit: (json['Kredit'] ?? 0.0).toDouble(),
      userName: json['UserName'],
      dateTime: json['DateTime'] != null ? DateTime.parse(json['DateTime']) : null,
      userAcc: json['UserAcc'],
      denda: json['Denda'] != null ? (json['Denda'] as num).toDouble() : null,
    );
  }
}
