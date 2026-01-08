import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/features/event/widgets/event_error.dart';
import 'package:sun_scan/features/event/widgets/event_loading.dart';
import 'package:sun_scan/features/event/views/tablet/section/event_tablet_banner.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../bloc/event/event_bloc.dart';
import '../../widgets/create_event_button.dart';
import '../../widgets/event_empty.dart';
import '../../widgets/event_loaded.dart';

class EventTabletView extends StatelessWidget {
  const EventTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlackColor,
      body: Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SUN SCAN',
              style: AppTextStyles.heading.copyWith(
                fontSize: 44,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<EventBloc, EventState>(
                builder: (context, state) {
                  if (state is EventLoading) {
                    return EventLoadingWidget();
                  }

                  if (state is EventError) {
                    return EventErrorWidget();
                  }

                  if (state is EventLoaded) {
                    final events = state.events;

                    if (events.isEmpty) {
                      return Column(
                        children: [
                          EventTabletBanner(activeEvent: null),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                EventEmptyWidget(),
                                const SizedBox(height: 24),
                                CreateEventButton(
                                  buttonType: CreateEventButtonType.tabletUp,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: EventLoadedWidget(
                            events: events,
                            isTablet: true,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: CreateEventButton(
                            buttonType: CreateEventButtonType.tabletUp,
                          ),
                        ),
                      ],
                    );
                  }

                  return EventErrorWidget();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
