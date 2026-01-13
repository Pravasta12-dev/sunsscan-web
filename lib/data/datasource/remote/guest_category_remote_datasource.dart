import 'dart:convert';

import 'package:sun_scan/data/model/params/create_guest_category_param.dart';

import '../../../core/endpoint/app_endpoint.dart';
import '../../../core/endpoint/app_header.dart';
import '../../../core/network/http_client.dart';
import '../../model/guest_category_model.dart';

abstract class GuestCategoryRemoteDatasource {
  Future<List<String>> sync(List<GuestCategoryModel> categories);
  Future<List<GuestCategoryModel>> fetchCategoriesByEventId(String eventId);
  Future<void> createGuestCategory({required CreateGuestCategoryParam param});
}

class GuestCategoryRemoteDatasourceImpl implements GuestCategoryRemoteDatasource {
  final CustomHttpClient _httpClient;
  final AppEndpoint _appEndpoint;

  GuestCategoryRemoteDatasourceImpl(this._httpClient, this._appEndpoint);

  factory GuestCategoryRemoteDatasourceImpl.create() {
    final httpClient = CustomHttpClient.create();
    final appEndpoint = AppEndpoint.create();

    return GuestCategoryRemoteDatasourceImpl(httpClient, appEndpoint);
  }

  @override
  Future<List<String>> sync(List<GuestCategoryModel> categories) async {
    final response = await _httpClient.post(
      _appEndpoint.guestCategoriesUrl,
      headers: AppHeader.jsonHeader,
      body: jsonEncode({'categories': categories.map((e) => e.toSyncJson()).toList()}),
    );

    /// response example:
    /// { "synced_ids": ["uuid1", "uuid2"] }
    final decoded = jsonDecode(response.body);

    return List<String>.from(decoded['synced_ids'] ?? []);
  }

  @override
  Future<List<GuestCategoryModel>> fetchCategoriesByEventId(String eventId) async {
    final response = await _httpClient.get(
      _appEndpoint.getGuestCategories(eventId),
      headers: AppHeader.jsonHeader,
    );

    final decoded = jsonDecode(response.body);
    final categories = decoded['guest_categories'] as List;

    return categories
        .map((e) => GuestCategoryModel.fromSyncJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<bool> createGuestCategory({required CreateGuestCategoryParam param}) async {
    final response = await _httpClient.post(
      _appEndpoint.createGuestCategory,
      headers: AppHeader.jsonHeader,
      body: jsonEncode(param.toJson()),
    );

    return response.statusCode == 200;
  }
}
