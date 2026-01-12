import 'package:flutter/material.dart';

import 'section/guest_scan_tabbar.dart';

class GuestScanTab extends StatefulWidget {
  const GuestScanTab({super.key});

  @override
  State<GuestScanTab> createState() => _GuestScanTabState();
}

class _GuestScanTabState extends State<GuestScanTab> {
  int selectedIndex = 0;

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
            GuestScanTabbar(
              selectedIndex: selectedIndex,
              onTabChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
            const SizedBox(height: 24),
            Expanded(
              child: IndexedStack(
                index: selectedIndex,
                children: const [
                  Center(child: Text('Scan Masuk Content')),
                  Center(child: Text('Scan Keluar Content')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
