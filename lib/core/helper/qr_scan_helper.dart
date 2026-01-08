class QrScanResult {
  final int eventId;

  final String raw;

  QrScanResult({required this.eventId, required this.raw});
}

class QrScanHelper {
  static QrScanResult parse(String rawQr) {
    // format: SUNSCAN|eventId|guestId|uuid
    if (!rawQr.startsWith('SUNSCAN|')) {
      throw Exception('QR tidak valid');
    }

    final parts = rawQr.split('|');

    if (parts.length < 3) {
      throw Exception('QR rusak');
    }

    final eventId = int.tryParse(parts[1]);

    if (eventId == null) {
      throw Exception('QR tidak dikenali');
    }

    return QrScanResult(eventId: eventId, raw: rawQr);
  }
}
