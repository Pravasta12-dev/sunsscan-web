import 'package:sun_scan/core/sync/connectivity_observer.dart';
import 'package:sun_scan/core/sync/sync_dispatcher.dart';
import 'package:sun_scan/data/datasource/local/guest_category_datasource.dart';

import 'core/sync/sync_engine.dart';
import 'core/sync/sync_pull_service.dart';
import 'core/sync/sync_registry.dart';
import 'core/sync/sync_state_storage.dart';
import 'core/ws/event_ws_controller.dart';
import 'core/ws/event_ws_service.dart';
import 'data/datasource/local/event_local_datasource.dart';
import 'data/datasource/local/guest_local_datasource.dart';
import 'data/datasource/local/souvenir_local_datasource.dart';
import 'data/datasource/remote/event_remote_datasource.dart';
import 'data/datasource/remote/guest_category_remote_datasource.dart';
import 'data/datasource/remote/guest_remote_datasource.dart';
import 'data/datasource/remote/souvenir_remote_datasource.dart';

class AppBootstrap {
  static SyncEngine? _syncEngine;
  static SyncPullService? _syncPullService;
  static EventWsController? _eventWsController;
  static ConnectivityObserver? _connectivity;

  static Future<void> initialized() async {
    /// 🔹 DATASOURCES
    final eventLocal = EventLocalDatasource.create();
    final guestLocal = GuestLocalDatasource.create();
    final guestCategoryLocal = GuestCategoryDatasource.create();
    final souvenirLocal = SouvenirLocalDataSource.create();

    final eventRemote = EventRemoteDatasourceImpl.create();
    final guestRemote = GuestRemoteDatasourceImpl.create();
    final guestCategoryRemote = GuestCategoryRemoteDatasourceImpl.create();
    final souvenirRemote = SouvenirRemoteDatasourceImpl.create();

    final syncState = SyncStateStorageImpl();

    /// 🔹 PULL SERVICE
    _syncPullService = SyncPullService(
      remote: eventRemote,
      eventLocal: eventLocal,
      guestLocal: guestLocal,
      syncState: syncState,
      guestCategoryLocal: guestCategoryLocal,
      souvenirLocal: souvenirLocal,
    );

    /// Initial pull to sync data from server to local
    await _syncPullService!.pull();

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
      souvenirLocalDatasource: souvenirLocal,
      souvenirRemoteDatasource: souvenirRemote,
    );

    _connectivity = ConnectivityObserver(_syncEngine!, _syncPullService!);
    _connectivity!.start();

    /// 🔹 INITIALIZE SYNC DISPATCHER
    SyncDispatcher.init(_syncEngine!);
  }

  static void dispose() {
    SyncDispatcher.dispose();

    _eventWsController?.stop();
    _syncEngine?.stop();

    _eventWsController = null;
    _syncEngine = null;
    _syncPullService = null;
  }
}
