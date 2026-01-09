// core/sync/sync_guard.dart
class SyncGuard {
  bool _running = false;

  bool get isRunning => _running;

  bool acquire() {
    if (_running) return false;
    _running = true;
    return true;
  }

  void release() {
    _running = false;
  }
}
