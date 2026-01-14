import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/features/guest/bloc/greeting/greeting_bloc.dart';
import 'package:sun_scan/features/guest/view/tablet/tab/greeting_screen/section/guest_greeting_header.dart';
import 'package:sun_scan/features/guest/view/tablet/tab/greeting_screen/section/guest_greeting_table.dart';

class GuestGreetingScreen extends StatefulWidget {
  const GuestGreetingScreen({super.key, required this.eventUuid});

  final String eventUuid;

  @override
  State<GuestGreetingScreen> createState() => _GuestGreetingScreenState();
}

class _GuestGreetingScreenState extends State<GuestGreetingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GreetingBloc>().loadGreetings(widget.eventUuid);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 40),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            const SizedBox(height: 24),
            GuestGreetingHeader(eventUuid: widget.eventUuid),
            const SizedBox(height: 24),
            const GuestGreetingTable(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
