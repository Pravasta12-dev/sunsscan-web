import 'dart:async';

class SyncDebouncer {
  final Duration delay;
  Timer? _timer;

  SyncDebouncer({this.delay = const Duration(seconds: 2)});

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
