import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:sun_scan/core/utils/capture_qr_bytes.dart';

Future<void> exportQrToGallery(BuildContext context, GlobalKey qrKey, String fileName) async {
  try {
    // Request permission terlebih dahulu
    final hasAccess = await Gal.hasAccess();
    if (!hasAccess) {
      final granted = await Gal.requestAccess();
      if (!granted) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Izin akses galeri ditolak')));
        }
        return;
      }
    }

    final bytes = await captureQrBytes(qrKey);

    // Simpan ke gallery menggunakan Gal
    await Gal.putImageBytes(bytes, album: 'SunScan');

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('QR berhasil disimpan ke galeri')));
    }
  } catch (e) {
    print('Error exporting QR to gallery: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export gagal: $e')));
    }
  }
}
