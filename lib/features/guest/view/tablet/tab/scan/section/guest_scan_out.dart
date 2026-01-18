import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/core/theme/app_colors.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';

import '../../../../../../../core/helper/qr_scan_helper.dart';
import '../../../../../bloc/guest/guest_bloc.dart';

class GuestScanOut extends StatelessWidget {
  const GuestScanOut({super.key});

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
              color: AppColors.redColor.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Mode Aktif: Scan Keluar',
              style: AppTextStyles.body.copyWith(
                color: AppColors.redColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void handleBarcodeScan(BuildContext context, String barcode) {
    try {
      final qrValue = QrScanHelper.parse(barcode);
      final raw = qrValue.raw.trim();
      context.read<GuestBloc>().scanCheckOut(raw);
    } catch (e) {
      print('[GuestScanPage] Error: ${e.toString()}');
    }
  }
}
