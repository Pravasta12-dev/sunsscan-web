import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CameraExternalDialog extends StatefulWidget {
  const CameraExternalDialog({super.key});

  @override
  State<CameraExternalDialog> createState() => _CameraExternalDialogState();
}

class _CameraExternalDialogState extends State<CameraExternalDialog> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadFlutterAsset('assets/camera/camera_single.html');
  }

  Future<void> _capture() async {
    final result = await _controller.runJavaScriptReturningResult(
      'window.capturePhoto();',
    );

    if (!mounted) return;
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 420,
        height: 420,
        child: Column(
          children: [
            Expanded(child: WebViewWidget(controller: _controller)),
            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton.icon(
                onPressed: _capture,
                icon: const Icon(Icons.camera),
                label: const Text('Ambil Foto'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
