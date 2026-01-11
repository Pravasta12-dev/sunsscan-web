import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImagePickerHelper {
  static Future<String?> pickImage({required ImageSource source}) async {
    final picker = ImagePicker();

    final file = await picker.pickImage(source: source, imageQuality: 70);

    if (file == null) return null;

    final bytes = await file.readAsBytes();

    // resize
    final image = img.decodeImage(bytes);
    if (image == null) return null;

    final resizedImage = img.copyResize(image, width: 512);

    final jpg = img.encodeJpg(resizedImage, quality: 70);

    return base64Encode(jpg);
  }

  static Future<String?> pickAndSaveImage({
    required ImageSource source,
    int maxWidth = 512,
    int quality = 75,
  }) async {
    final picker = ImagePicker();

    if (Platform.isIOS || Platform.isMacOS || Platform.isWindows) {
      if (source == ImageSource.camera) {
        // On these platforms, camera source is not supported
        return null;
      }
    }

    final picked = await picker.pickImage(
      source: source,
      maxWidth: maxWidth.toDouble(),
      imageQuality: quality,
    );

    if (picked == null) return null;

    final dir = await getApplicationDocumentsDirectory();

    final guestDir = Directory('${dir.path}/guests');

    if (!await guestDir.exists()) {
      await guestDir.create(recursive: true);
    }

    final fileName = const Uuid().v4();
    final savedPath = '${guestDir.path}/$fileName.jpg';

    final savedFile = await File(picked.path).copy(savedPath);

    return savedFile.path;
  }
}
