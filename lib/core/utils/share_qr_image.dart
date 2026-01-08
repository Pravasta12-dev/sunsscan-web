import 'dart:io';

import 'package:share_plus/share_plus.dart';
import 'package:sun_scan/core/network/network_logger.dart';

Future<void> shareQrImage({
  required File file,
  required String guestName,
  String? caption,
}) async {
  // Gunakan caption jika tersedia, jika tidak gunakan text default
  final shareText = caption ?? 'Undangan untuk $guestName';

  final params = ShareParams(text: shareText, files: [XFile(file.path)]);
  final result = await SharePlus.instance.share(params);

  if (result.status != ShareResultStatus.success) {
    appNetworkLogger(
      endpoint: 'share_qr_image',
      payload: params.toString(),
      response: result.toString(),
    );
  }
}
