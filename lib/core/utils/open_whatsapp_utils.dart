import 'package:url_launcher/url_launcher.dart';

Future<void> openWhatsApp({
  required String phone,
  required String message,
}) async {
  try {
    final formattedPhone = phone.startsWith('0')
        ? '62${phone.substring(1)}'
        : phone;

    final encodedMessage = Uri.encodeComponent(message);

    final url = Uri.parse('https://wa.me/$formattedPhone?text=$encodedMessage');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak bisa membuka WhatsApp';
    }
  } catch (e) {
    throw 'Error membuka WhatsApp: $e';
  }
}
