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
    if (response.events != null) {
      for (final event in response.events!) {
        await _eventLocal.upsertFromRemote(event);
      }
    }

    if (response.guests != null) {
      for (final guest in response.guests!) {
        await _guestLocal.upsertFromRemote(guest);
      }
    }

    /// 🔹 GUEST CATEGORIES
    if (response.guestCategories != null) {
      for (final category in response.guestCategories!) {
        await _guestCategoryLocal.upsertFromRemote(category);
      }
    }

    /// 🔹 SAVE SERVER TIME
    await _syncState.setLastSyncAt(response.serverTime);
  }
}
