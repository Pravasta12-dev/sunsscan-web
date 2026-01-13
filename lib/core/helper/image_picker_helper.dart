import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

enum PickImageSource { camera, gallery, file }

class ImagePickerHelper {
  static final _picker = ImagePicker();

  static Future<String?> pickAndSave({
    required PickImageSource source,
    int maxWidth = 512,
    int quality = 75,
  }) async {
    File? originalFile;

    if (kIsWeb) {
      print('Picking image from web using FilePicker');
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result == null) return null;
      originalFile = File(result.files.single.path!);
    } else if (Platform.isAndroid || Platform.isIOS) {
      print('Picking image from mobile using ImagePicker');
      if (source == PickImageSource.camera || source == PickImageSource.gallery) {
        final picked = await _picker.pickImage(
          source: source == PickImageSource.camera ? ImageSource.camera : ImageSource.gallery,
          imageQuality: quality,
        );

        if (picked == null) return null;

        originalFile = File(picked.path);
      }
    } else {
      print('Picking image from desktop using FilePicker');
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result == null) return null;
      originalFile = File(result.files.single.path!);
    }

    if (originalFile == null) return null;

    return _resizeAndSave(file: originalFile, maxWidth: maxWidth, quality: quality);
  }

  static Future<String?> _resizeAndSave({
    required File file,
    required int maxWidth,
    required int quality,
  }) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return null;

    final resized = img.copyResize(image, width: maxWidth);
    final jpg = img.encodeJpg(resized, quality: quality);

    final dir = await getApplicationDocumentsDirectory();
    final guestDir = Directory('${dir.path}/guests');
    if (!await guestDir.exists()) {
      await guestDir.create(recursive: true);
    }

    final fileName = '${const Uuid().v4()}.jpg';
    final savedFile = File('${guestDir.path}/$fileName');

    await savedFile.writeAsBytes(jpg);
    return savedFile.path;
  }

  /// Helper UI logic
  static bool canUseCamera() {
    return Platform.isAndroid || Platform.isIOS;
  }
}
