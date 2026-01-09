// core/sync/sync_queue.dart
class SyncQueue<T> {
  final Future<List<T>> Function(int limit) fetchPending;
  final Future<void> Function(List<String> ids) markAsSynced;

  SyncQueue({required this.fetchPending, required this.markAsSynced});
}
