import 'package:flutter/material.dart';
import 'package:sun_scan/features/guest/view/tablet/tab/dashboard_tab/section/dashboard_stats.dart';

import 'dashboard_history_activity.dart';

class DashboardGuestStatisticTab extends StatelessWidget {
  const DashboardGuestStatisticTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 3,
            child: Column(children: [const DashboardStats(), const SizedBox(height: 16)]),
          ),
          const SizedBox(width: 16),
          Flexible(flex: 2, child: const DashboardHistoryActivity()),
        ],
      ),
    );
  }
}
