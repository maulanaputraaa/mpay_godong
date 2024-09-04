import 'package:flutter/material.dart';

class AktivasiMenu extends StatelessWidget {
  AktivasiMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Warna bayangan
                spreadRadius: 2, // Penyebaran bayangan
                blurRadius: 8, // Jarak blur bayangan
                offset: const Offset(0, 4), // Posisi bayangan
              ),
            ],
          ),
          child: const Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'AKTIF',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    'AB1234', // Kode acak di sebelah kanan "AKTIF"
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'QR Code',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    'ON', // "ON" di sebelah kanan "QR Code"
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildIconWithText(context, Icons.check, 'Aktivasi'),
                _buildIconWithText(context, Icons.close, 'Cek Aktivasi'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildIconWithText(context, Icons.qr_code, 'QRCode ON'),
                _buildIconWithText(context, Icons.qr_code, 'QRCode OFF'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildIconWithText(BuildContext context, IconData icon, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 50,
          color: Colors.green,
        ),
        const SizedBox(height: 8.0),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
