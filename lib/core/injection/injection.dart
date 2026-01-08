import 'package:sun_scan/core/injection/env.dart';
import 'package:sun_scan/core/network/http_client.dart';

import '../../main.dart';

class Injection {
  static const String fontFamily = 'DMSans';
  // static final AppSharedPrefKey sharedPrefKey = AppSharedPrefKey();
  // static final HttpClient httpClient = AppHttpClient.create();
  // static final HeaderProvider headerProvider = AppHeaderProvider.create();
  static final HttpClient httpClient = CustomHttpClient.create();
  static final String baseUrl = appEnvironment.baseURL;
  static final int? basePort = appEnvironment.basePort;
  static final bool isDevelopMode = appEnvironment.isDevelopMode;
  static final String baseScheme = appEnvironment.baseScheme;
  static final String apiKey = appEnvironment.apiKey;
}
