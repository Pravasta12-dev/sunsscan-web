import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/features/web/bloc/guest_web/guest_web_bloc.dart';
import 'package:sun_scan/features/web/pages/guests/section/web_guest_header.dart';
import 'package:sun_scan/features/web/pages/guests/section/web_guest_table.dart';

class WebGuestList extends StatefulWidget {
  const WebGuestList({super.key, required this.eventId, required this.eventName});

  final String eventId;
  final String eventName;

  @override
  State<WebGuestList> createState() => _WebGuestListState();
}

class _WebGuestListState extends State<WebGuestList> {
  @override
  void initState() {
    super.initState();

    context.read<GuestWebBloc>().fetchGuestsByEventId(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 49.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            WebGuestHeader(eventId: widget.eventId, eventName: widget.eventName),
            const SizedBox(height: 20),
            const WebGuestTable(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
