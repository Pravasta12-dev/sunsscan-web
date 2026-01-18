// A bridge widget to connect HID barcode input with the application.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sun_scan/core/helper/barcode/hid_barcode_helper.dart';

class HIDInputBridge extends StatefulWidget {
  const HIDInputBridge({super.key, required this.helper});

  final HidBarcodeHelper helper;

  @override
  State<HIDInputBridge> createState() => _HIDInputBridgeState();
}

class _HIDInputBridgeState extends State<HIDInputBridge> {
  late final bool Function(KeyEvent) _keyEventHandler;

  @override
  void initState() {
    super.initState();
    _keyEventHandler = (KeyEvent event) {
      widget.helper.handleKey(event);
      return false;
    };

    HardwareKeyboard.instance.addHandler(_keyEventHandler);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }

  @override
  void dispose() {
    super.dispose();
    HardwareKeyboard.instance.removeHandler(_keyEventHandler);
  }
}
