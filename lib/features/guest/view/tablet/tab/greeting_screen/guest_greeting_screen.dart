import 'package:flutter/material.dart';
import 'package:sun_scan/features/guest/view/tablet/tab/greeting_screen/section/guest_greeting_header.dart';
import 'package:sun_scan/features/guest/view/tablet/tab/greeting_screen/section/guest_greeting_table.dart';

class GuestGreetingScreen extends StatelessWidget {
  const GuestGreetingScreen({super.key, required this.eventUuid});

  final String eventUuid;

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
            const GuestGreetingHeader(),
            const SizedBox(height: 24),
            const GuestGreetingTable(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
