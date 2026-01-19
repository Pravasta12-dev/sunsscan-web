import 'dart:convert';

import '../../../core/endpoint/app_endpoint.dart';
import '../../../core/endpoint/app_header.dart';
import '../../../core/network/http_client.dart';
import '../../model/guest_session_model.dart';

abstract class GuestSessionRemoteDatasource {
  Future<List<String>> sync(List<GuestSessionModel> sessions);
}

class GuestSessionRemoteDatasourceImpl implements GuestSessionRemoteDatasource {
  final CustomHttpClient _httpClient;
  final AppEndpoint _appEndpoint;

  GuestSessionRemoteDatasourceImpl(this._httpClient, this._appEndpoint);

  factory GuestSessionRemoteDatasourceImpl.create() {
    final httpClient = CustomHttpClient.create();
    final appEndpoint = AppEndpoint.create();

    return GuestSessionRemoteDatasourceImpl(httpClient, appEndpoint);
  }

  @override
  Future<List<String>> sync(List<GuestSessionModel> sessions) async {
    final response = await _httpClient.post(
      _appEndpoint.guestSessionsUrl,
      headers: AppHeader.jsonHeader,
      body: jsonEncode({'sessions': sessions.map((e) => e.toJson(forOnline: true)).toList()}),
    );

    /// response example:
    /// { "synced_ids": ["uuid1", "uuid2"] }
    final decoded = jsonDecode(response.body);

    return List<String>.from(decoded['synced_ids'] ?? []);
  }
}
