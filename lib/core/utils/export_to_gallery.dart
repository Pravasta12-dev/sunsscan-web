import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:sun_scan/core/utils/capture_qr_bytes.dart';

Future<void> exportQrToGallery(
  BuildContext context,
  GlobalKey qrKey,
  String fileName,
) async {
  try {
    final bytes = await captureQrBytes(qrKey);

    // Simpan ke gallery menggunakan Gal
    await Gal.putImageBytes(bytes, album: 'SunScan');

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR berhasil disimpan ke galeri')),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Export gagal: $e')));
    }
  }
}
