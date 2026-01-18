import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:sun_scan/core/helper/barcode/barcode_scanner.dart';

import 'hid_input_bridge.dart';

class HidBarcodeHelper {
  final OnBarcodeScanned onBarcodeScanned;
  final int minLength;
  final Duration timeoutDuration;

  HidBarcodeHelper({
    required this.onBarcodeScanned,
    this.minLength = 4,
    this.timeoutDuration = const Duration(milliseconds: 300),
  });

  final StringBuffer _barcodeBuffer = StringBuffer();

  Timer? _timeoutTimer;

  bool handleKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.enter) {
      _finish();
      return false;
    }

    final label = key.keyLabel;

    if (label.length == 1) {
      _barcodeBuffer.write(label);
      _resetTimeout();
    }

    return false;
  }

  void _resetTimeout() {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(timeoutDuration, _finish);
  }

  void _finish() {
    _timeoutTimer?.cancel();

    final result = _barcodeBuffer.toString();
    _barcodeBuffer.clear();

    if (result.length >= minLength) {
      onBarcodeScanned(result);
    }
  }

  void dispose() {
    _timeoutTimer?.cancel();
    _barcodeBuffer.clear();
  }
}

class HIDBarcodeScanner implements BarcodeScanner {
  final OnBarcodeScanned onBarcodeScanned;
  late HidBarcodeHelper _helper;

  HIDBarcodeScanner({required this.onBarcodeScanned}) {
    _helper = HidBarcodeHelper(onBarcodeScanned: onBarcodeScanned);
  }

  @override
  void dispose() {
    _helper.dispose();
  }

  @override
  Widget build() {
    return HIDInputBridge(helper: _helper);
  }
}
