import 'package:flutter/material.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/core/theme/app_colors.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';

import '../test_scan/guest_scan_test_scan.dart';

class GuestScanIn extends StatelessWidget {
  const GuestScanIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(Assets.gifs.qris.path, width: 300, height: 300),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            width: 800,
            decoration: BoxDecoration(
              color: AppColors.greenColor.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Mode Aktif: Scan Masuk',
              style: AppTextStyles.body.copyWith(
                color: AppColors.greenColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const GuestScanTest(scanMode: ScanMode.scanIn),
        ],
      ),
    );
  }
}
