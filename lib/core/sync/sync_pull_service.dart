import 'package:sun_scan/data/datasource/local/guest_category_datasource.dart';

import '../../data/datasource/local/event_local_datasource.dart';
import '../../data/datasource/local/guest_local_datasource.dart';
import '../../data/datasource/remote/event_remote_datasource.dart';
import 'sync_state_storage.dart';

class SyncPullService {
  final EventRemoteDatasource _remote;
  final EventLocalDatasource _eventLocal;
  final GuestLocalDatasource _guestLocal;
  final SyncStateStorage _syncState;
  final GuestCategoryDatasource _guestCategoryLocal;

  SyncPullService({
    required EventRemoteDatasource remote,
    required EventLocalDatasource eventLocal,
    required GuestLocalDatasource guestLocal,
    required SyncStateStorage syncState,
    required GuestCategoryDatasource guestCategoryLocal,
  }) : _remote = remote,
       _eventLocal = eventLocal,
       _guestLocal = guestLocal,
       _syncState = syncState,
       _guestCategoryLocal = guestCategoryLocal;

  Future<void> pull() async {
    final lastSyncAt = await _syncState.getLastSyncAt();

    final response = await _remote.pullAll(lastSyncAt: lastSyncAt);

    /// 🔹 EVENTS
    if (response.events != null && response.events!.isNotEmpty) {
      for (final event in response.events!) {
        try {
          await _eventLocal.upsertFromRemote(event);
        } catch (e) {
          print('[SyncPullService] Failed to upsert event: $e');
        }
      }
    } else {}

    if (response.guests != null && response.guests!.isNotEmpty) {
      for (final guest in response.guests!) {
        try {
          await _guestLocal.upsertFromRemote(guest);
        } catch (e) {
          print('[SyncPullService] Failed to upsert guest: $e');
        }
      }
    } else {}

    /// 🔹 GUEST CATEGORIES
    if (response.guestCategories != null &&
        response.guestCategories!.isNotEmpty) {
      for (final category in response.guestCategories!) {
        try {
          await _guestCategoryLocal.upsertFromRemote(category);
        } catch (e) {
          print('[SyncPullService] Failed to upsert guest category: $e');
        }
      }
    } else {}

    /// 🔹 SAVE SERVER TIME
    await _syncState.setLastSyncAt(response.serverTime);
  }
}
