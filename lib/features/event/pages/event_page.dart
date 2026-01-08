import 'package:flutter/material.dart';
import 'package:sun_scan/core/helper/responsive_builder.dart';
import 'package:sun_scan/features/event/views/mobile/event_mobile_view.dart';
import 'package:sun_scan/features/event/views/tablet/event_tablet_view.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: const EventMobileView(),
      tabletUp: const EventTabletView(),
    );
  }
}
