import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: MobileScanner(
        onDetect: (BarcodeCapture barcodeCapture) {
          final List<Barcode> barcodes = barcodeCapture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue == null) {
              print('Failed to scan Barcode');
            } else {
              final String code = barcode.rawValue!;
              print('Barcode found! $code');
              // Tambahkan logika untuk menangani hasil scan di sini
            }
          }
        },
      ),
    );
  }
}
