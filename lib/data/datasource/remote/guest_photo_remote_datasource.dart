import 'dart:convert';

import 'package:http/http.dart';

import '../../../core/endpoint/app_endpoint.dart';
import '../../../core/endpoint/app_header.dart';
import '../../../core/network/http_client.dart';
import '../../model/guest_photo_model.dart';

abstract class GuestPhotoRemoteDatasource {
  Future<String> upload(GuestPhotoModel photo);
  Future<List<String>> sync(List<GuestPhotoModel> photos);
}

class GuestPhotoRemoteDatasourceImpl implements GuestPhotoRemoteDatasource {
  final CustomHttpClient _httpClient;
  final AppEndpoint _appEndpoint;

  GuestPhotoRemoteDatasourceImpl(this._httpClient, this._appEndpoint);

  factory GuestPhotoRemoteDatasourceImpl.create() {
    final httpClient = CustomHttpClient.create();
    final appEndpoint = AppEndpoint.create();

    return GuestPhotoRemoteDatasourceImpl(httpClient, appEndpoint);
  }

  @override
  Future<String> upload(GuestPhotoModel photo) async {
    final response = await _httpClient.postMultipart(
      _appEndpoint.uploadGuestPhotoUrl,
      files: [await MultipartFile.fromPath('file', photo.filePath)],
      fields: {
        'photo_uuid': photo.photoUuid,
        'guest_uuid': photo.guestUuid,
        'event_uuid': photo.eventUuid,
        'photo_type': photo.photoType.name,
      },
    );

    final decoded = jsonDecode(response.body);
    return decoded['file_url'] as String;
  }

  @override
  Future<List<String>> sync(List<GuestPhotoModel> photos) async {
    final response = await _httpClient.post(
      _appEndpoint.guestPhotoUrl,
      headers: AppHeader.jsonHeader,
      body: jsonEncode({'guest_photos': photos.map((e) => e.toSyncPayload()).toList()}),
    );

    /// response example:
    /// { "synced_ids": ["uuid1", "uuid2"] }
    final decoded = jsonDecode(response.body);

    return List<String>.from(decoded['synced_ids'] ?? []);
  }
}
