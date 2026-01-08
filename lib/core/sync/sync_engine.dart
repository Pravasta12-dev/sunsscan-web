import 'dart:async';

import 'package:sun_scan/core/network/network_logger.dart';
import 'package:sun_scan/core/sync/sync_config.dart';
import 'package:sun_scan/core/sync/sync_runner.dart';

/// [SyncEngine] manages periodic synchronization of data using multiple [SyncRunner]s.
class SyncEngine {
  final SyncConfig config;
  final List<SyncRunner> runners;

  Timer? _timer;
  bool _isRunning = false;

  SyncEngine({required this.config, required this.runners});

  // Start the periodic sync process
  void start() {
    stop(); // Ensure no duplicate timers

    _timer = Timer.periodic(config.interval, (_) async {
      await syncOnce();
    });
  }

  // Stop the periodic sync process
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  // Perform a single sync operation
  Future<void> syncOnce() async {
    if (_isRunning) return;

    _isRunning = true;
    try {
      for (final runner in runners) {
        await runner.run(config.batchSize);
      }
    } catch (e) {
      appNetworkLogger(
        endpoint: 'sync',
        payload: e.toString(),
        response: 'Error during sync',
      );
    } finally {
      _isRunning = false;
    }
  }
}
