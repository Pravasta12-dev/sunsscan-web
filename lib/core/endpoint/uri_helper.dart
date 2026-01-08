import 'package:sun_scan/core/injection/injection.dart';

class UriHelper {
  static Uri createUrl({
    required String host,
    String? path,
    Map<String, dynamic>? queryParameters,
  }) {
    return Uri(
      scheme: Injection.baseScheme,
      host: host,
      port: Injection.basePort,
      path: path,
      queryParameters: queryParameters?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }
}
