// core/ws/event_ws_controller.dart
import 'package:sun_scan/core/ws/event_ws_service.dart';

import '../sync/sync_pull_service.dart';

class EventWsController {
  final EventWsService _ws;
  final SyncPullService _pull;

  EventWsController(this._ws, this._pull);

  void start() {
    _ws.connect(
      onEvent: (type) async {
        print('[WsController] Received event: $type');
        try {
          print('[WsController] Pulling data from server...');
          await _pull.pull();
          print('[WsController] Pull completed successfully!');
        } catch (e) {
          print('[WsController] Pull failed: $e');
        }
      },
    );
  }

  void stop() {
    _ws.disconnect();
  }
}
