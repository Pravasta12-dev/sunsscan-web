import 'dart:async';

import 'package:sun_scan/core/sync/sync_config.dart';
import 'package:sun_scan/core/sync/sync_debouncer.dart';
import 'package:sun_scan/core/sync/sync_runner.dart';

import 'sync_guard.dart';

class SyncEngine {
  final SyncConfig config;
  final List<SyncRunner> runners;
  final SyncGuard _guard = SyncGuard();
  final _debouncer = SyncDebouncer();

  Timer? _timer;

  SyncEngine({required this.config, required this.runners});

  void start() {
    stop();

    _timer = Timer.periodic(config.interval, (_) {
      syncOnce();
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> syncOnce() async {
    if (!_guard.acquire()) return;

    try {
      for (final runner in runners) {
        await runner.run(config.batchSize);
      }
    } catch (_) {
      // log error kalau mau
    } finally {
      _guard.release();
    }
  }

  void trigger() {
    _debouncer.call(() async {
      await syncOnce();
    });
  }
}
