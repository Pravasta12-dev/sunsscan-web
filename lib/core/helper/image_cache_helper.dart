import 'dart:convert';
import 'dart:typed_data';

class ImageCacheHelper {
  static final Map<String, Uint8List> _imageCache = {};

  static Uint8List? getImageFromCache(String key) {
    if (_imageCache.containsKey(key)) {
      return _imageCache[key];
    }

    final bytes = base64Decode(key);

    _imageCache[key] = bytes;
    return bytes;
  }

  static void clearCache() {
    _imageCache.clear();
  }
}
