import 'package:sun_scan/core/sync/sync_engine.dart';
import 'package:sun_scan/photo_sync_service.dart';

class SyncDispatcher {
  static SyncEngine? _engine;
  static PhotoSyncService? photoSyncService;

  /// Initialize with SyncEngine instance (call once at app startup)
  static void init(SyncEngine engine, {required PhotoSyncService photoService}) {
    _engine = engine;
    photoSyncService = photoService;
  }

  /// Trigger sync on local changes
  static void onLocalChange() async {
    if (_engine == null || photoSyncService == null) return;

    // Sync guest dulu (agar guest_uuid sudah ada di server)
    await _engine?.syncOnce();

    // Baru sync photo (saat ini guest_uuid sudah dikenali server)
    await photoSyncService!.syncPendingPhotos();
  }

  /// Dispose and clear reference
  static void dispose() {
    _engine = null;
    photoSyncService = null;
  }

  /// Check if initialized
  static bool get isInitialized => _engine != null;
}
