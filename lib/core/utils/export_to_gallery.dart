// Conditional export untuk support web dan mobile
export 'export_to_gallery_stub.dart' if (dart.library.io) 'export_to_gallery_mobile.dart';
