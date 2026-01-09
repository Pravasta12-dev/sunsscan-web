class SyncConfig {
  final Duration interval;
  final int batchSize;

  SyncConfig({this.interval = const Duration(seconds: 10), this.batchSize = 20});
}
