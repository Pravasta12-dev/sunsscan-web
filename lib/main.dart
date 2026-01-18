import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sun_scan/app_bootstrap.dart';
import 'package:sun_scan/core/injection/env.dart';
import 'package:sun_scan/core/storage/database.dart';

import 'main_app.dart';

Environment appEnvironment = Environment.development;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

  // Lock orientation untuk mobile (bukan web)
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS)) {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final logicalWidth = view.physicalSize.width / view.devicePixelRatio;

    final isTabletUp = logicalWidth >= 600;

    if (!isTabletUp) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  // Initialize database untuk desktop (bukan web)
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.linux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize database dan bootstrap hanya untuk mobile/desktop
  if (!kIsWeb) {
    await DatabaseHelper().database;
    await AppBootstrap.initialized();
  } else {
    // Untuk web, skip database dan sync (tidak support)
    print('[Web] Running in web mode - database and sync disabled');
  }

  runApp(const MyApp());
}
