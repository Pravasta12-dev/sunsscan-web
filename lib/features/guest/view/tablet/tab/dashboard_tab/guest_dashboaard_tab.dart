import 'package:flutter/material.dart';
import 'package:sun_scan/features/guest/view/tablet/tab/dashboard_tab/section/dashboard_action_tab.dart';

import 'section/dashboard_guest_statistic.dart';

class GuestDashboaardTab extends StatelessWidget {
  const GuestDashboaardTab({super.key});

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
            const DashboardActionTab(),
            const SizedBox(height: 24),
            const DashboardGuestStatisticTab(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
