class QrScanResult {
  final String eventId;

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

    final eventId = parts[1];
    print('[QrScanHelper] Parsed QR: eventId=$eventId, raw=$rawQr');

    return QrScanResult(eventId: eventId, raw: rawQr);
  }
}
