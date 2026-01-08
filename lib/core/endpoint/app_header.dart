import 'package:sun_scan/core/injection/injection.dart';

class AppHeader {
  static Map<String, String> jsonHeader = {
    'Content-Type': 'application/json',
    'X-API-KEY': Injection.apiKey,
  };
}
