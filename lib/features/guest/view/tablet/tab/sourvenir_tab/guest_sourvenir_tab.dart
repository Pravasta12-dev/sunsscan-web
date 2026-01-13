import 'package:flutter/material.dart';
import 'package:sun_scan/features/guest/view/tablet/tab/sourvenir_tab/section/guest_souvenir_banner_info.dart';
import 'package:sun_scan/features/guest/view/tablet/tab/sourvenir_tab/section/guest_souvenir_header.dart';

import 'section/guest_souvenir_table.dart';

class GuestSourvenirTab extends StatelessWidget {
  const GuestSourvenirTab({super.key, required this.eventUuid});

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
            const GuestSouvenirHeader(),
            const SizedBox(height: 24),
            const GuestSouvenirBannerInfo(),
            const SizedBox(height: 24),
            GuestSouvenirTable(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
