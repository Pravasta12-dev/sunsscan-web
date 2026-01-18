import 'package:flutter/material.dart';
import 'package:sun_scan/core/helper/barcode/hid_barcode_helper.dart';

typedef OnBarcodeScanned = void Function(String barcode);

abstract class BarcodeScanner {
  void dispose();
  Widget build();
}

class BarcodeScannerFactory {
  static BarcodeScanner createHidBarcodeScanner({
    required OnBarcodeScanned onBarcodeScanned,
  }) {
    return HIDBarcodeScanner(onBarcodeScanned: onBarcodeScanned);
  }
}
