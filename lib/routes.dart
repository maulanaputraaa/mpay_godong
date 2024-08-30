import 'package:flutter/material.dart';
import 'package:mpay_godong/angsuran/angsuran/angsuran_feature_screen.dart';
import 'package:mpay_godong/angsuran/angsuran_screen.dart';
import 'package:mpay_godong/angsuran/tagihan/tagihan_screen.dart';
import 'package:mpay_godong/contact/contact_screen.dart';
import 'package:mpay_godong/laporan/fasilitas_anggota/fasilitas_anggota_screen.dart';
import 'package:mpay_godong/laporan/laporan_angsuran/laporan_angsuran_screen.dart';
import 'package:mpay_godong/laporan/laporan_screen.dart';
import 'package:mpay_godong/laporan/laporan_simpanan/laporan_simpanan_screen.dart';
import 'package:mpay_godong/laporan/rekap_laporan/rekap_laporan_screen.dart';
import 'package:mpay_godong/layouts/app.dart';
import 'package:mpay_godong/login/login_screen.dart';
import 'package:mpay_godong/pengaturan/pengaturan_screen.dart';
import 'package:mpay_godong/qr_scan/qr_scan_screen.dart';
import 'package:mpay_godong/simpanan/penarikan/penarikan_screen.dart';
import 'package:mpay_godong/simpanan/saldo/saldo_screen.dart';
import 'package:mpay_godong/simpanan/setoran/setoran_screen.dart';
import 'package:mpay_godong/simpanan/simpanan_screen.dart';
import 'package:mpay_godong/splash_screen/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  AppScreen.routeName: (context) => const AppScreen(),
  ContactScreen.routeName: (context) => ContactScreen(),
  QRScanScreen.routeName: (context) => const QRScanScreen(),
  SimpananScreen.routeName: (context) => const SimpananScreen(),
  SetoranScreen.routeName: (context) => const SetoranScreen(),
  PenarikanScreen.routeName: (context) => const PenarikanScreen(),
  SaldoScreen.routeName: (context) => const SaldoScreen(),
  AngsuranScreen.routeName: (context) => const AngsuranScreen(),
  AngsuranFeatureScreen.routeName: (context) => const AngsuranFeatureScreen(),
  TagihanScreen.routeName: (context) => const TagihanScreen(),
  LaporanScreen.routeName: (context) => const LaporanScreen(),
  LaporanSimpananScreen.routeName: (context) => const LaporanSimpananScreen(),
  LaporanAngsuranScreen.routeName: (context) => const LaporanAngsuranScreen(),
  RekapLaporanScreen.routeName: (context) => const RekapLaporanScreen(),
  FasilitasAnggotaScreen.routeName: (context) => const FasilitasAnggotaScreen(),
  PengaturanScreen.routeName: (context) => const PengaturanScreen(),
};
