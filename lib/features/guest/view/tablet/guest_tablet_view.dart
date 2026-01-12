import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/features/guest/bloc/guest_tab/guest_tab_cubit.dart';
import 'package:sun_scan/features/guest/view/tablet/section/guest_tablet_banner.dart';
import 'package:sun_scan/features/guest/view/tablet/tab/dashboard_tab/guest_dashboaard_tab.dart';
import 'package:sun_scan/features/guest/view/tablet/tab/greeting_screen/guest_greeting_screen.dart';
import 'package:sun_scan/features/guest/view/tablet/tab/guest_list/guest_list_tab.dart';
import 'package:sun_scan/features/guest/view/tablet/tab/sourvenir_tab/guest_sourvenir_tab.dart';

import '../../../../data/model/event_model.dart';
import '../../bloc/guest/guest_bloc.dart';
import 'tab/scan/guest_scan_tab.dart';

class GuestTabletView extends StatefulWidget {
  const GuestTabletView({super.key, required this.activeEvent});

  final EventModel activeEvent;

  @override
  State<GuestTabletView> createState() => _GuestTabletViewState();
}

class _GuestTabletViewState extends State<GuestTabletView> {
  @override
  void initState() {
    super.initState();
    context.read<GuestBloc>().loadGuests(widget.activeEvent.eventUuid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GuestTabCubit(),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GuestTabletBanner(event: widget.activeEvent),

            Expanded(
              child: BlocBuilder<GuestTabCubit, GuestTab>(
                builder: (context, state) {
                  switch (state) {
                    case GuestTab.dashboard:
                      return GuestDashboaardTab();
                    case GuestTab.guests:
                      return GuestListTab(eventUuid: widget.activeEvent.eventUuid ?? '');
                    case GuestTab.scan:
                      return GuestScanTab();
                    case GuestTab.souvenirs:
                      return GuestSourvenirTab(eventUuid: widget.activeEvent.eventUuid ?? '');
                    case GuestTab.layers:
                      return GuestGreetingScreen(eventUuid: widget.activeEvent.eventUuid ?? '');
                  }
                },
              ),
            ),

            // Expanded(
            //   child: BlocBuilder<GuestBloc, GuestState>(
            //     builder: (context, state) {
            //       if (state is GuestLoading) {
            //         return GuestLoadingWidget();
            //       }

            //       if (state is GuestError) {
            //         return GuestErrorWidget();
            //       }

            //       if (state is GuestLoaded) {
            //         final guests = state.guests;

            //         return Column(
            //           spacing: 30.0,
            //           children: [
            //             Expanded(
            //               child: Column(
            //                 children: [
            //                   Flexible(
            //                     flex: 1,
            //                     child: GuestTabletContentHeader(
            //                       eventId: widget.activeEvent.eventUuid ?? '',
            //                     ),
            //                   ),
            //                   SizedBox(height: 24),
            //                   Flexible(
            //                     flex: 3,
            //                     child: GuestTabletContentBottom(guests: guests),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         );
            //       }

            //       return SizedBox.shrink();
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
