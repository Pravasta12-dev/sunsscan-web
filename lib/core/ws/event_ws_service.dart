import 'dart:convert';

import 'package:sun_scan/core/injection/injection.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class EventWsService {
  WebSocketChannel? _channel;
  bool _connected = false;

  bool get isConnected => _connected;

  void connect({required void Function(String type) onEvent}) {
    if (_connected) return;

    final scheme = Injection.baseScheme == 'https' ? 'wss' : 'ws';

    // Build URI dengan Uri constructor (handle nullable port)
    final uri = Uri(
      scheme: scheme,
      host: Injection.baseUrl,
      port: Injection.basePort, // Null akan diabaikan secara otomatis
      path: '/ws',
    );

    print('[EventWsService] Connecting to WebSocket at $uri');

    _channel = WebSocketChannel.connect(uri);
    _connected = true;

    _channel!.stream.listen(
      (message) {
        try {
          final data = jsonDecode(message);
          final type = data['type'] as String?;
          if (type != null) {
            onEvent(type);
          }
        } catch (_) {
          // ignore malformed message
        }
      },
      onDone: () {
        _connected = false;
      },
      onError: (_) {
        _connected = false;
      },
    );
  }

  void disconnect() {
    if (!_connected) return;

    _channel?.sink.close(status.goingAway);
    _channel = null;
    _connected = false;
  }
}
