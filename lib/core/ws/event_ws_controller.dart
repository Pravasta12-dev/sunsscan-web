import 'package:sun_scan/core/ws/event_ws_service.dart';

import '../sync/sync_pull_service.dart';

class EventWsController {
  final EventWsService _ws;
  final SyncPullService _pullService;

  bool _pulling = false;

  EventWsController(this._ws, this._pullService);

  void start() {
    _ws.connect(
      onEvent: (type) async {
        if (_pulling) return;

        if (type.startsWith('event') || type.startsWith('guest')) {
          _pulling = true;
          try {
            await _pullService.pull();
          } finally {
            _pulling = false;
          }
        }
      },
    );
  }

  void stop() {
    _ws.disconnect();
  }
}
