import 'package:flutter/widgets.dart';
import 'package:sun_scan/core/helper/responsive_builder.dart';
import 'package:sun_scan/features/splash/view/mobile/splash_screen.dart';
import 'package:sun_scan/features/web/pages/web_main.dart';

import '../view/tablet/splash_screen_tablet.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: const SplashScreen(),
      tabletUp: const SplashScreenTablet(),
      web: const WebMain(),
    );
  }
}
