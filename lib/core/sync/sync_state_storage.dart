import 'package:shared_preferences/shared_preferences.dart';

abstract class SyncStateStorage {
  Future<DateTime?> getLastSyncAt();
  Future<void> setLastSyncAt(DateTime time);
}

class SyncStateStorageImpl implements SyncStateStorage {
  static const _key = 'last_sync_at';

  @override
  Future<DateTime?> getLastSyncAt() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    return value != null ? DateTime.parse(value) : null;
  }

  @override
  Future<void> setLastSyncAt(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, time.toIso8601String());
  }
}
