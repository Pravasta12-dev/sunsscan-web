import 'package:sun_scan/data/datasource/local/guest_category_datasource.dart';
import 'package:sun_scan/data/datasource/local/guest_session_local_datasource.dart';
import 'package:sun_scan/data/datasource/local/souvenir_local_datasource.dart';

import '../../data/datasource/local/event_local_datasource.dart';
import '../../data/datasource/local/greeting_local_datasource.dart';
import '../../data/datasource/local/guest_local_datasource.dart';
import '../../data/datasource/local/guest_photo_local_datasource.dart';
import '../../data/datasource/remote/event_remote_datasource.dart';
import 'sync_state_storage.dart';

class SyncPullService {
  final EventRemoteDatasource _remote;
  final EventLocalDatasource _eventLocal;
  final GuestLocalDatasource _guestLocal;
  final SyncStateStorage _syncState;
  final GuestCategoryDatasource _guestCategoryLocal;
  final SouvenirLocalDataSource _souvenirLocal;
  final GreetingLocalDatasource _greetingLocal;
  final GuestPhotoLocalDatasource _guestPhotoLocal;
  final GuestSessionLocalDatasource _guestSessionLocal;

  SyncPullService({
    required EventRemoteDatasource remote,
    required EventLocalDatasource eventLocal,
    required GuestLocalDatasource guestLocal,
    required SyncStateStorage syncState,
    required GuestCategoryDatasource guestCategoryLocal,
    required SouvenirLocalDataSource souvenirLocal,
    required GreetingLocalDatasource greetingLocal,
    required GuestPhotoLocalDatasource guestPhotoLocal,
    required GuestSessionLocalDatasource guestSessionLocal,
  }) : _remote = remote,
       _eventLocal = eventLocal,
       _guestLocal = guestLocal,
       _syncState = syncState,
       _guestCategoryLocal = guestCategoryLocal,
       _souvenirLocal = souvenirLocal,
       _greetingLocal = greetingLocal,
       _guestPhotoLocal = guestPhotoLocal,
       _guestSessionLocal = guestSessionLocal;

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

    if (response.greetingScreens != null && response.greetingScreens!.isNotEmpty) {
      print('[SyncPullService] 👋 Memproses ${response.greetingScreens!.length} greetings...');
      for (final greeting in response.greetingScreens!) {
        try {
          await _greetingLocal.upsertFormRemote(greeting);
        } catch (e, st) {
          print('[SyncPullService] ❌ Failed to upsert greeting: $e');
          print('[SyncPullService] Stack trace: $st');
        }
      }
    } else {
      print('[SyncPullService] ⚠️ Tidak ada greetings dari server');
    }

    /// 🔹 GUEST PHOTOS
    if (response.guestPhotos != null && response.guestPhotos!.isNotEmpty) {
      print('[SyncPullService] 📸 Memproses ${response.guestPhotos!.length} guest photos...');

      for (final photo in response.guestPhotos!) {
        try {
          await _guestPhotoLocal.upsertFromRemote(photo);
        } catch (e, st) {
          print('[SyncPullService] ❌ Failed to upsert guest photo: $e');
          print('[SyncPullService] Stack trace: $st');
        }
      }
    } else {
      print('[SyncPullService] ⚠️ Tidak ada guest photos dari server');
    }

    if (response.guestSessions != null && response.guestSessions!.isNotEmpty) {
      print('[SyncPullService] ⏱️  Memproses ${response.guestSessions!.length} guest sessions...');

      for (final session in response.guestSessions!) {
        try {
          await _guestSessionLocal.upsertFromRemote(session);
        } catch (e, st) {
          print('[SyncPullService] ❌ Failed to upsert guest session: $e');
          print('[SyncPullService] Stack trace: $st');
        }
      }
    } else {
      print('[SyncPullService] ⚠️ Tidak ada guest sessions dari server');
    }

    /// 🔹 SAVE SERVER TIME
    await _syncState.setLastSyncAt(response.serverTime);
  }
}
