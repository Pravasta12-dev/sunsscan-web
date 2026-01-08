import 'package:sun_scan/data/datasource/local/guest_category_datasource.dart';

import 'core/sync/sync_engine.dart';
import 'core/sync/sync_pull_service.dart';
import 'core/sync/sync_registry.dart';
import 'core/sync/sync_state_storage.dart';
import 'core/ws/event_ws_controller.dart';
import 'core/ws/event_ws_service.dart';
import 'data/datasource/local/event_local_datasource.dart';
import 'data/datasource/local/guest_local_datasource.dart';
import 'data/datasource/remote/event_remote_datasource.dart';
import 'data/datasource/remote/guest_category_remote_datasource.dart';
import 'data/datasource/remote/guest_remote_datasource.dart';

class AppBootstrap {
  static SyncEngine? _syncEngine;
  static SyncPullService? _syncPullService;
  static EventWsController? _eventWsController;

  static Future<void> initialized() async {
    /// 🔹 DATASOURCES
    final eventLocal = EventLocalDatasource.create();
    final guestLocal = GuestLocalDatasource.create();
    final guestCategoryLocal = GuestCategoryDatasource.create();

    final eventRemote = EventRemoteDatasourceImpl.create();
    final guestRemote = GuestRemoteDatasourceImpl.create();
    final guestCategoryRemote = GuestCategoryRemoteDatasourceImpl.create();

    final syncState = SyncStateStorageImpl();

    /// 🔹 PULL SERVICE
    _syncPullService = SyncPullService(
      remote: eventRemote,
      eventLocal: eventLocal,
      guestLocal: guestLocal,
      syncState: syncState,
      guestCategoryLocal: guestCategoryLocal,
    );

    /// 🔹 INITIAL PULL (APP START) - Non-blocking, continue if failed
    try {
      await _syncPullService!.pull();
      print('[AppBootstrap] ✅ Initial sync completed');
    } catch (e) {
      print('[AppBootstrap] ⚠️ Initial sync failed: $e');
      print('[AppBootstrap] 📱 App will continue in offline mode');
      // App tetap jalan, sync akan retry otomatis nanti
    }

    /// 🔹 WS CONTROLLER
    final wsService = EventWsService();
    _eventWsController = EventWsController(wsService, _syncPullService!);
    _eventWsController!.start();

    /// 🔹 PUSH ENGINE (PENDING → SERVER)
    _syncEngine = SyncRegistry.create(
      eventLocalDatasource: eventLocal,
      eventRemoteDatasource: eventRemote,
      guestLocalDatasource: guestLocal,
      guestRemoteDatasource: guestRemote,
      guestCategoryDatasource: guestCategoryLocal,
      guestCategoryRemoteDatasource: guestCategoryRemote,
    );

    _syncEngine!.start();
  }

  static void dispose() {
    _eventWsController?.stop();
    _syncEngine?.stop();

    _eventWsController = null;
    _syncEngine = null;
    _syncPullService = null;
  }
}
