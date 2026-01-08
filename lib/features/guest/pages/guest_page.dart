import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/core/helper/responsive_builder.dart';
import 'package:sun_scan/data/model/event_model.dart';
import 'package:sun_scan/features/event/bloc/event/event_bloc.dart';
import 'package:sun_scan/features/guest/view/mobile/guest_view.dart';
import 'package:sun_scan/features/guest/view/tablet/guest_tablet_view.dart';

class GuestPage extends StatelessWidget {
  const GuestPage({super.key, required this.activeEvent});

  final EventModel activeEvent;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        // Cari event terbaru berdasarkan ID
        EventModel currentEvent = activeEvent;

        if (state is EventLoaded) {
          final updatedEvent = state.events.firstWhere(
            (e) => e.eventUuid == activeEvent.eventUuid,
            orElse: () => activeEvent,
          );
          currentEvent = updatedEvent;
        }

        return ResponsiveBuilder(
          mobile: GuestView(
            activeEvent: currentEvent,
            eventName: currentEvent.name,
          ),
          tabletUp: GuestTabletView(activeEvent: currentEvent),
        );
      },
    );
  }
}
