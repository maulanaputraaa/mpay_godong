import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mpay_godong/layouts/top_bar.dart';

class QRScanScreen extends StatelessWidget {
  const QRScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(title: Text("Qr Scanner")),
      body: MobileScanner(
        onDetect: (BarcodeCapture barcodeCapture) {
          final List<Barcode> barcodes = barcodeCapture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue == null) {
              Fluttertoast.showToast(
                  msg: 'Failed to scan Barcode',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  textColor: Colors.white,
                  backgroundColor: Colors.red);
            } else {
              final String code = barcode.rawValue!;
              Fluttertoast.showToast(
                  msg: 'Barcode found! $code',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  textColor: Colors.white,
                  backgroundColor: Colors.green);
              // Tambahkan logika untuk menangani hasil scan di sini
            }
          }
        },
      ),
    );
  }
}
