import 'dart:convert';

import 'package:sun_scan/data/model/greeting_screen_model.dart';

import '../../../core/endpoint/app_endpoint.dart';
import '../../../core/endpoint/app_header.dart';
import '../../../core/network/http_client.dart';

abstract class GreetingRemoteDatasource {
  Future<List<String>> sync(List<GreetingScreenModel> greetings);
}

class GreetingRemoteDatasourceImpl implements GreetingRemoteDatasource {
  final CustomHttpClient _httpClient;
  final AppEndpoint _appEndpoint;

  GreetingRemoteDatasourceImpl(this._httpClient, this._appEndpoint);

  factory GreetingRemoteDatasourceImpl.create() {
    final httpClient = CustomHttpClient.create();
    final appEndpoint = AppEndpoint.create();

    return GreetingRemoteDatasourceImpl(httpClient, appEndpoint);
  }

  @override
  Future<List<String>> sync(List<GreetingScreenModel> greetings) async {
    final response = await _httpClient.post(
      _appEndpoint.greetingsUrl,
      headers: AppHeader.jsonHeader,
      body: jsonEncode({'greetings': greetings.map((e) => e.toOnlineJson()).toList()}),
    );

    /// response example:
    /// { "synced_ids": ["uuid1", "uuid2"] }
    final decoded = jsonDecode(response.body);

    return List<String>.from(decoded['synced_ids'] ?? []);
  }
}
