class Nasabah {
  final String cabangEntry;
  final String nama;
  final String kode;
  final String tgl;
  final String? kodeLama;
  final String? tglLahir;
  final String? tempatLahir;
  final String? statusPerkawinan;
  final String? ktp;
  final String? agama;
  final String? alamat;
  final String? telepon;
  final String? email;

  Nasabah({
    required this.cabangEntry,
    required this.nama,
    required this.kode,
    required this.tgl,
    this.kodeLama,
    this.tglLahir,
    this.tempatLahir,
    this.statusPerkawinan,
    this.ktp,
    this.agama,
    this.alamat,
    this.telepon,
    this.email,
  });

  factory Nasabah.fromJson(Map<String, dynamic> json) {
    return Nasabah(
      cabangEntry: json['CabangEntry'] ?? '',
      nama: json['Nama'] ?? '',
      kode: json['Kode'] ?? '',
      tgl: json['Tgl'] ?? '',
      kodeLama: json['KodeLama'],
      tglLahir: json['TglLahir'],
      tempatLahir: json['TempatLahir'],
      statusPerkawinan: json['StatusPerkawinan'],
      ktp: json['KTP'],
      agama: json['Agama'],
      alamat: json['Alamat'],
      telepon: json['Telepon'],
      email: json['Email'],
    );
  }
}
