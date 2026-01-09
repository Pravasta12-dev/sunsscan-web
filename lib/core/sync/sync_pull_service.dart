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
    print('[SyncPullService] ===== PULL STARTED =====');
    final lastSyncAt = await _syncState.getLastSyncAt();
    print('[SyncPullService] Last sync at: $lastSyncAt');

    final response = await _remote.pullAll(lastSyncAt: lastSyncAt);

    print('[SyncPullService] Pull response received');
    print('[SyncPullService] Events count: ${response.events?.length ?? 0}');
    print('[SyncPullService] Guests count: ${response.guests?.length ?? 0}');
    print('[SyncPullService] Categories count: ${response.guestCategories?.length ?? 0}');

    /// 🔹 EVENTS
    if (response.events != null && response.events!.isNotEmpty) {
      print('[SyncPullService] Upserting ${response.events!.length} events...');
      for (final event in response.events!) {
        try {
          print('[SyncPullService] Upserting event: ${event.eventUuid}');
          await _eventLocal.upsertFromRemote(event);
          print('[SyncPullService] ✅ Event upserted: ${event.eventUuid}');
        } catch (e) {
          print('[SyncPullService] ❌ Error upserting event: $e');
        }
      }
    } else {
      print('[SyncPullService] No events to upsert');
    }

    if (response.guests != null && response.guests!.isNotEmpty) {
      print('[SyncPullService] Upserting ${response.guests!.length} guests...');
      for (final guest in response.guests!) {
        try {
          print('[SyncPullService] Upserting guest: ${guest.guestUuid}');
          await _guestLocal.upsertFromRemote(guest);
          print('[SyncPullService] ✅ Guest upserted: ${guest.guestUuid}');
        } catch (e) {
          print('[SyncPullService] ❌ Error upserting guest: $e');
        }
      }
    } else {
      print('[SyncPullService] No guests to upsert');
    }

    /// 🔹 GUEST CATEGORIES
    if (response.guestCategories != null && response.guestCategories!.isNotEmpty) {
      print('[SyncPullService] Upserting ${response.guestCategories!.length} categories...');
      for (final category in response.guestCategories!) {
        try {
          print('[SyncPullService] Upserting category: ${category.categoryUuid}');
          await _guestCategoryLocal.upsertFromRemote(category);
          print('[SyncPullService] ✅ Category upserted: ${category.categoryUuid}');
        } catch (e) {
          print('[SyncPullService] ❌ Error upserting category: $e');
        }
      }
    } else {
      print('[SyncPullService] No categories to upsert');
    }

    /// 🔹 SAVE SERVER TIME
    await _syncState.setLastSyncAt(response.serverTime);
    print('[SyncPullService] ===== PULL COMPLETED =====');
  }
}
