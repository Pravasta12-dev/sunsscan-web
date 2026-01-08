import 'dart:convert';

import 'package:sun_scan/core/endpoint/app_endpoint.dart';
import 'package:sun_scan/core/network/http_client.dart';

import '../../../core/endpoint/app_header.dart';
import '../../model/guests_model.dart';

abstract class GuestRemoteDatasource {
  Future<List<String>> sync(List<GuestsModel> guests);
  Future<List<GuestsModel>> fetchGuestsByEventId(String eventId);
}

class GuestRemoteDatasourceImpl implements GuestRemoteDatasource {
  final CustomHttpClient _httpClient;
  final AppEndpoint _appEndpoint;

  GuestRemoteDatasourceImpl(this._httpClient, this._appEndpoint);

  factory GuestRemoteDatasourceImpl.create() {
    final httpClient = CustomHttpClient.create();
    final appEndpoint = AppEndpoint.create();

    return GuestRemoteDatasourceImpl(httpClient, appEndpoint);
  }

  @override
  Future<List<String>> sync(List<GuestsModel> guests) async {
    final response = await _httpClient.post(
      _appEndpoint.guestsUrl,
      headers: AppHeader.jsonHeader,
      body: jsonEncode({'guests': guests.map((e) => e.toSyncJson()).toList()}),
    );

    /// response example:
    /// { "synced_ids": ["uuid1", "uuid2"] }
    final decoded = jsonDecode(response.body);

    return List<String>.from(decoded['synced_ids'] ?? []);
  }

  @override
  Future<List<GuestsModel>> fetchGuestsByEventId(String eventId) async {
    final response = await _httpClient.get(
      _appEndpoint.fetchPublicGuestByEventUuid(eventId),
      headers: AppHeader.jsonHeader,
    );

    print('[GuestRemoteDatasource] Response body: ${response.body}');

    final decoded = jsonDecode(response.body);

    // Defensive: cek apakah response adalah Map atau List
    List<dynamic> guestList;
    if (decoded is List) {
      print('[GuestRemoteDatasource] Response is List');
      guestList = decoded;
    } else if (decoded is Map<String, dynamic>) {
      print('[GuestRemoteDatasource] Response is Map, keys: ${decoded.keys}');
      // Jika response adalah object, ambil key 'guests' atau 'data'
      guestList = decoded['guests'] ?? decoded['data'] ?? [];
    } else {
      print(
        '[GuestRemoteDatasource] Unknown response type: ${decoded.runtimeType}',
      );
      guestList = [];
    }

    print('[GuestRemoteDatasource] Parsed ${guestList.length} guests');

    return guestList
        .map((e) => GuestsModel.fromJsonOnline(e as Map<String, dynamic>))
        .toList();
  }
}
