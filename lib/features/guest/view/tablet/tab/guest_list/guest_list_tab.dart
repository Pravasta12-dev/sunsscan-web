import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/features/guest/view/tablet/tab/guest_list/section/guest_list_content.dart';
import 'package:sun_scan/features/guest/view/tablet/tab/guest_list/section/guest_list_header.dart';

import '../../../../bloc/guest/guest_bloc.dart';

class GuestListTab extends StatefulWidget {
  const GuestListTab({
    super.key,
    required this.eventUuid,
    required this.eventName,
  });

  final String eventUuid;
  final String eventName;

  @override
  State<GuestListTab> createState() => _GuestListTabState();
}

class _GuestListTabState extends State<GuestListTab> {
  @override
  void initState() {
    super.initState();
    context.read<GuestBloc>().loadGuests(widget.eventUuid);
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
            GuestListHeader(
              eventId: widget.eventUuid,
              eventName: widget.eventName,
            ),
            const SizedBox(height: 24),
            const GuestListContent(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
