import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';
import 'package:sun_scan/data/model/event_model.dart';
import 'package:sun_scan/features/web/bloc/event_web/event_web_bloc.dart';
import 'package:sun_scan/features/web/pages/web_dashboard_banner.dart';
import 'package:sun_scan/features/web/pages/guests/web_guest_list.dart';

import '../../guest/bloc/guest_tab/guest_tab_cubit.dart';

class WebDashboard extends StatefulWidget {
  const WebDashboard({super.key, required this.eventCode});

  final String eventCode;

  @override
  State<WebDashboard> createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebDashboard> {
  @override
  void initState() {
    super.initState();
    context.read<EventWebBloc>().fetchEventByCode(widget.eventCode);
    context.read<GuestTabCubit>().setTab(GuestTab.guests);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EventWebBloc, EventWebState>(
        builder: (context, stateEvent) {
          bool isLoading = stateEvent is EventWebLoading;

          if (stateEvent is EventWebError) {
            return Center(
              child: Text(
                'Error loading event: ${stateEvent.message}',
                style: AppTextStyles.bodyLarge,
              ),
            );
          }

          var eventWeb = stateEvent is EventWebLoaded ? stateEvent.event : null;

          return Column(
            children: [
              WebDashboardBanner(isLoading: isLoading, event: eventWeb ?? EventModel.empty()),
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : stateEvent is EventWebError
                    ? Center(
                        child: Text(
                          'Error event: ${stateEvent.message}',
                          style: AppTextStyles.bodyLarge,
                        ),
                      )
                    : Expanded(
                        child: BlocBuilder<GuestTabCubit, GuestTab>(
                          builder: (context, state) {
                            switch (state) {
                              case GuestTab.guests:
                                return WebGuestList(
                                  eventId: eventWeb?.eventUuid ?? '',
                                  eventName: eventWeb?.name ?? '',
                                );
                              case GuestTab.souvenirs:
                                return Center(
                                  child: Text('Souvenir Tab is under construction on Web.'),
                                );
                              default:
                                return Center(
                                  child: Text('Tab ${state.name} is not available on Web.'),
                                );
                            }
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
