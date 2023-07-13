import 'package:flutter/material.dart';
import 'package:qr_scanner/ui/first_page.dart';

void main() {
  runApp(MaterialApp(
    title: "QR Code Scanner",
    home: QRCodeScannerScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
