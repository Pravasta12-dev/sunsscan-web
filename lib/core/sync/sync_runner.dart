// core/sync/sync_runner.dart
import 'sync_queue.dart';

class SyncRunner<T> {
  final SyncQueue<T> queue;
  final Future<void> Function(List<T> items) pushRemote;
  final String Function(T) getId;

  SyncRunner({required this.queue, required this.pushRemote, required this.getId});

  Future<void> run(int batchSize) async {
    final pending = await queue.fetchPending(batchSize);
    if (pending.isEmpty) return;

    await pushRemote(pending);

    final ids = pending.map(getId).toList();
    await queue.markAsSynced(ids);
  }
}
