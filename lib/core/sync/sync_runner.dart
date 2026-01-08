import 'package:sun_scan/core/sync/sync_queue.dart';

class SyncRunner<T> {
  final SyncQueue<T> queue;
  final Future<void> Function(List<T> items) remoteSync;
  final String Function(T) getId;

  SyncRunner({
    required this.queue,
    required this.remoteSync,
    required this.getId,
  });

  Future<void> run(int batchSize) async {
    final pendingItems = await queue.fetchPending(batchSize);
    if (pendingItems.isEmpty) {
      return;
    }

    await remoteSync(pendingItems);

    final ids = pendingItems.map(getId).toList();
    await queue.markAsSynced(ids);
  }
}
