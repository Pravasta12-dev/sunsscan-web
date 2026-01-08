class SyncGuard {
  static bool _isRunning = false;

  static bool tryLock() {
    if (_isRunning) return false;

    _isRunning = true;
    return true;
  }

  static void unlock() {
    _isRunning = false;
  }
}
