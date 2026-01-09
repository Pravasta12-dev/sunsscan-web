import 'dart:async';
import 'dart:convert';

import 'package:sun_scan/core/injection/injection.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// core/ws/event_ws_service.dart
class EventWsService {
  WebSocketChannel? _channel;
  bool _connected = false;

  int _retry = 0;
  Timer? _reconnectTimer;
  void Function(String type)? _onEventCallback; // Simpan callback

  void connect({required void Function(String type) onEvent}) {
    _onEventCallback = onEvent; // Simpan callback untuk reconnect

    if (_connected) return;

    final scheme = Injection.baseScheme == 'https' ? 'wss' : 'ws';

    final uri = Uri(scheme: scheme, host: Injection.baseUrl, port: Injection.basePort, path: '/ws');

    print('[WebSocket] Connecting to: $uri');
    _channel = WebSocketChannel.connect(uri);
    _connected = true;
    _retry = 0;

    _channel!.stream.listen(
      (message) {
        print('[WebSocket] Received message: $message');
        final data = jsonDecode(message);
        final type = data['type'];
        print('[WebSocket] Event type: $type');
        print('[WebSocket] Callback available: ${_onEventCallback != null}');
        print('[WebSocket] About to call onEvent with type: $type');
        if (type != null) {
          print('[WebSocket] Calling onEvent...');
          onEvent(type);
          print('[WebSocket] onEvent called successfully');
        }
      },
      onDone: () {
        print('[WebSocket] Connection closed');
        _scheduleReconnect();
      },
      onError: (error) {
        print('[WebSocket] Error: $error');
        _scheduleReconnect();
      },
    );
  }

  void _scheduleReconnect() {
    _connected = false;
    _channel = null;

    final delay = Duration(seconds: 2 << _retry);
    _retry = (_retry + 1).clamp(0, 5);

    print('[WebSocket] Reconnecting in ${delay.inSeconds}s...');
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      if (_onEventCallback != null) {
        print('[WebSocket] Attempting reconnect...');
        connect(onEvent: _onEventCallback!); // Gunakan callback yang disimpan
      }
    });
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _connected = false;
    _onEventCallback = null; // Clear callback
  }
}
