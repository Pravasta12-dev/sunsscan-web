import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/features/event/widgets/event_loaded.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../bloc/event/event_bloc.dart';
import '../../widgets/create_event_button.dart';
import 'section/event_banner.dart';
import '../../widgets/event_empty.dart';
import '../../widgets/event_error.dart';
import '../../widgets/event_loading.dart';

class EventMobileView extends StatelessWidget {
  const EventMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SUN SCAN',
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          context.read<EventBloc>().loadEvents();
        },
        child: BlocBuilder<EventBloc, EventState>(
          builder: (context, state) {
            if (state is EventLoading) {
              return EventLoadingWidget();
            }

            if (state is EventLoaded) {
              final events = state.events;

              if (events.isEmpty) {
                return Column(
                  children: [
                    EventBanner(activeEvent: null),
                    Expanded(child: EventEmptyWidget()),
                    CreateEventButton(),
                    const SizedBox(height: 16),
                  ],
                );
              }

              return Column(
                children: [
                  Expanded(child: EventLoadedWidget(events: events)),
                  CreateEventButton(),
                  const SizedBox(height: 16),
                ],
              );
            }

            if (state is EventError) {
              return EventErrorWidget();
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
