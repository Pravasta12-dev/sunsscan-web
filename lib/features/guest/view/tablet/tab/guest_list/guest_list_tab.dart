import 'package:flutter/material.dart';
import 'package:sun_scan/features/guest/view/tablet/tab/guest_list/section/guest_list_content.dart';
import 'package:sun_scan/features/guest/view/tablet/tab/guest_list/section/guest_list_header.dart';

class GuestListTab extends StatelessWidget {
  const GuestListTab({super.key, required this.eventUuid, required this.eventName});

  final String eventUuid;
  final String eventName;

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
            GuestListHeader(eventId: eventUuid, eventName: eventName),
            const SizedBox(height: 24),
            const GuestListContent(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
