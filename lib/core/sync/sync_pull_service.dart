import 'package:sun_scan/data/datasource/local/guest_category_datasource.dart';
import 'package:sun_scan/data/datasource/local/souvenir_local_datasource.dart';

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
  final SouvenirLocalDataSource _souvenirLocal;

  SyncPullService({
    required EventRemoteDatasource remote,
    required EventLocalDatasource eventLocal,
    required GuestLocalDatasource guestLocal,
    required SyncStateStorage syncState,
    required GuestCategoryDatasource guestCategoryLocal,
    required SouvenirLocalDataSource souvenirLocal,
  }) : _remote = remote,
       _eventLocal = eventLocal,
       _guestLocal = guestLocal,
       _syncState = syncState,
       _guestCategoryLocal = guestCategoryLocal,
       _souvenirLocal = souvenirLocal;

  Future<void> pull() async {
    final lastSyncAt = await _syncState.getLastSyncAt();

    final response = await _remote.pullAll(lastSyncAt: lastSyncAt);

    print('[SyncPullService] 📥 Response dari server:');
    print('[SyncPullService] - Events: ${response.events?.length ?? 0}');
    print('[SyncPullService] - Guests: ${response.guests?.length ?? 0}');
    print('[SyncPullService] - Guest Categories: ${response.guestCategories?.length ?? 0}');
    print('[SyncPullService] - Server Time: ${response.serverTime}');

    /// 🔹 EVENTS
    if (response.events != null && response.events!.isNotEmpty) {
      print('[SyncPullService] 📝 Memproses ${response.events!.length} events...');
      for (final event in response.events!) {
        try {
          print('[SyncPullService] - Upsert event: ${event.eventUuid} )');
          await _eventLocal.upsertFromRemote(event);
          print('[SyncPullService] ✅ Event berhasil di-upsert');
        } catch (e, st) {
          print('[SyncPullService] ❌ Failed to upsert event: $e');
          print('[SyncPullService] Stack trace: $st');
        }
      }
    } else {
      print('[SyncPullService] ⚠️ Tidak ada events dari server');
    }

    if (response.guests != null && response.guests!.isNotEmpty) {
      print('[SyncPullService] 👥 Memproses ${response.guests!.length} guests...');
      for (final guest in response.guests!) {
        try {
          await _guestLocal.upsertFromRemote(guest);
        } catch (e, st) {
          print('[SyncPullService] ❌ Failed to upsert guest: $e');
          print('[SyncPullService] Stack trace: $st');
        }
      }
    } else {
      print('[SyncPullService] ⚠️ Tidak ada guests dari server');
    }

    /// 🔹 GUEST CATEGORIES
    if (response.guestCategories != null && response.guestCategories!.isNotEmpty) {
      print(
        '[SyncPullService] 🏷️  Memproses ${response.guestCategories!.length} guest categories...',
      );
      for (final category in response.guestCategories!) {
        try {
          await _guestCategoryLocal.upsertFromRemote(category);
        } catch (e, st) {
          print('[SyncPullService] ❌ Failed to upsert guest category: $e');
          print('[SyncPullService] Stack trace: $st');
        }
      }
    } else {
      print('[SyncPullService] ⚠️ Tidak ada guest categories dari server');
    }

    /// 🔹 SOUVENIRS
    if (response.souvenirs != null && response.souvenirs!.isNotEmpty) {
      print('[SyncPullService] 🎁 Memproses ${response.souvenirs!.length} souvenirs...');
      for (final souvenir in response.souvenirs!) {
        try {
          await _souvenirLocal.upsertFromRemote(souvenir);
        } catch (e, st) {
          print('[SyncPullService] ❌ Failed to upsert souvenir: $e');
          print('[SyncPullService] Stack trace: $st');
        }
      }
    } else {
      print('[SyncPullService] ⚠️ Tidak ada souvenirs dari server');
    }

    /// 🔹 SAVE SERVER TIME
    await _syncState.setLastSyncAt(response.serverTime);
  }
}
