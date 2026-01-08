import 'dart:convert';

import 'package:sun_scan/core/endpoint/app_endpoint.dart';
import 'package:sun_scan/core/endpoint/app_header.dart';
import 'package:sun_scan/core/network/http_client.dart';

import '../../../core/sync/sync_pull_response.dart';
import '../../model/event_model.dart';

abstract class EventRemoteDatasource {
  Future<List<String>> sync(List<EventModel> events);
  Future<SyncPullResponse> pullAll({DateTime? lastSyncAt});
  Future<EventModel> fetchEventByCode(String eventCode);
}

class EventRemoteDatasourceImpl implements EventRemoteDatasource {
  final AppEndpoint _appEndpoint;
  final CustomHttpClient _httpClient;

  EventRemoteDatasourceImpl(this._appEndpoint, this._httpClient);

  factory EventRemoteDatasourceImpl.create() {
    final appEndpoint = AppEndpoint.create();
    final httpClient = CustomHttpClient.create();

    return EventRemoteDatasourceImpl(appEndpoint, httpClient);
  }

  @override
  Future<List<String>> sync(List<EventModel> events) async {
    final response = await _httpClient.post(
      _appEndpoint.eventsUrl,
      headers: AppHeader.jsonHeader,
      body: jsonEncode({'events': events.map((e) => e.toSyncJson()).toList()}),
    );

    /// response example:
    /// { "synced_ids": ["uuid1", "uuid2"] }
    final decoded = jsonDecode(response.body);

    return List<String>.from(decoded['synced_ids'] ?? []);
  }

  @override
  Future<SyncPullResponse> pullAll({DateTime? lastSyncAt}) async {
    final res = await _httpClient.post(
      _appEndpoint.syncPull,
      headers: AppHeader.jsonHeader,
      body: jsonEncode({'last_sync_at': lastSyncAt?.toIso8601String()}),
    );

    final decoded = jsonDecode(res.body) as Map<String, dynamic>;

    final result = SyncPullResponse.fromJson(decoded);

    return result;
  }

  @override
  Future<EventModel> fetchEventByCode(String eventCode) async {
    final response = await _httpClient.get(
      _appEndpoint.fetchPublicEventByCode(eventCode),
      headers: AppHeader.jsonHeader,
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    return EventModel.fromJsonOnline(decoded);
  }
}
