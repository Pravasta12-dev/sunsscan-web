import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/features/web/bloc/event_web/event_web_bloc.dart';
import 'package:sun_scan/features/web/pages/widgets/web_guest_banner.dart';
import 'package:sun_scan/features/web/pages/widgets/web_guest_list.dart';

class WebGuestPage extends StatefulWidget {
  const WebGuestPage({super.key, required this.eventCode});

  final String eventCode;

  @override
  State<WebGuestPage> createState() => _WebGuestPageState();
}

class _WebGuestPageState extends State<WebGuestPage> {
  @override
  void initState() {
    super.initState();
    context.read<EventWebBloc>().fetchEventByCode(widget.eventCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<EventWebBloc, EventWebState>(
          builder: (context, state) {
            if (state is EventWebLoading) {
              return const CircularProgressIndicator();
            } else if (state is EventWebLoaded) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    WebGuestBanner(activeEvent: state.event),
                    const SizedBox(height: 20),
                    Expanded(
                      child: WebGuestList(eventId: state.event.eventUuid ?? ''),
                    ),
                  ],
                ),
              );
            } else if (state is EventWebError) {
              return Text('Error: ${state.message}');
            }
            return const Text('Please wait...');
          },
        ),
      ),
    );
  }
}
