import 'dart:async';

import 'package:sun_scan/core/sync/sync_engine.dart';
import 'package:sun_scan/core/sync/sync_pull_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityObserver {
  final SyncEngine _syncEngine;
  final SyncPullService _syncPullService;
  StreamSubscription? _connectivitySubscription;

  ConnectivityObserver(this._syncEngine, this._syncPullService);

  void start() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) async {
      if (results.isNotEmpty && !results.contains(ConnectivityResult.none)) {
        await _syncPullService.pull();
        _syncEngine.trigger();
      }
    });
  }

  void stop() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }
}
