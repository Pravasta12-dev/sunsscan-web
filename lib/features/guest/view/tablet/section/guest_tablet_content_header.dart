import 'package:flutter/material.dart';
import 'package:sun_scan/features/guest/view/mobile/widgets/action_card.dart';

import '../../../../../core/routes/app_transition.dart';
import '../../mobile/guest_scan_page.dart';
import '../../mobile/insert_guest_page.dart';

class GuestTabletContentHeader extends StatelessWidget {
  const GuestTabletContentHeader({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: ActionCard(
              icon: Icons.qr_code_scanner_outlined,
              title: 'Scan QR',
              subtitle: 'Scan tamu datang dan pulang',
              onTap: () {
                AppTransition.pushTransition(
                  context,
                  GuestScanPage(activeEventId: eventId),
                );
              },
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: ActionCard(
              icon: Icons.qr_code_scanner_outlined,
              title: 'Generate QR',
              subtitle: 'Input tamu baru',
              onTap: () {
                AppTransition.pushTransition(
                  context,
                  GuestInsertPage(eventId: eventId, eventName: ''),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
