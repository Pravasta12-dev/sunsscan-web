import 'dart:convert';

import '../../../core/endpoint/app_endpoint.dart';
import '../../../core/endpoint/app_header.dart';
import '../../../core/network/http_client.dart';
import '../../model/souvenir_model.dart';

abstract class SouvenirRemoteDatasource {
  Future<List<String>> sync(List<SouvenirModel> souvenirs);
}

class SouvenirRemoteDatasourceImpl implements SouvenirRemoteDatasource {
  final CustomHttpClient _httpClient;
  final AppEndpoint _appEndpoint;

  SouvenirRemoteDatasourceImpl(this._httpClient, this._appEndpoint);

  factory SouvenirRemoteDatasourceImpl.create() {
    final httpClient = CustomHttpClient.create();
    final appEndpoint = AppEndpoint.create();

    return SouvenirRemoteDatasourceImpl(httpClient, appEndpoint);
  }

  @override
  Future<List<String>> sync(List<SouvenirModel> souvenirs) async {
    final response = await _httpClient.post(
      _appEndpoint.souvenirsUrl,
      headers: AppHeader.jsonHeader,
      body: jsonEncode({'souvenirs': souvenirs.map((e) => e.toOnlineJson()).toList()}),
    );

    /// response example:
    /// { "synced_ids": ["uuid1", "uuid2"] }
    final decoded = jsonDecode(response.body);

    return List<String>.from(decoded['synced_ids'] ?? []);
  }
}
