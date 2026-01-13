import 'package:flutter/material.dart';

Future<void> exportQrToGallery(BuildContext context, GlobalKey qrKey, String fileName) async {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export ke galeri tidak didukung di platform ini')),
    );
  }
}
