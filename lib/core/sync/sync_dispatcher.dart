import 'package:sun_scan/core/sync/sync_engine.dart';

class SyncDispatcher {
  static SyncEngine? _engine;

  /// Initialize with SyncEngine instance (call once at app startup)
  static void init(SyncEngine engine) {
    _engine = engine;
  }

  /// Trigger sync on local changes
  static void onLocalChange() {
    _engine?.trigger();
  }

  /// Dispose and clear reference
  static void dispose() {
    _engine = null;
  }

  /// Check if initialized
  static bool get isInitialized => _engine != null;
}
