import 'package:flutter/material.dart';
import 'package:sun_scan/core/theme/app_colors.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';

class GuestStatusBadge extends StatelessWidget {
  final bool isCheckedIn;
  final bool isCheckedOut;

  const GuestStatusBadge({
    super.key,
    required this.isCheckedIn,
    required this.isCheckedOut,
  });

  @override
  Widget build(BuildContext context) {
    // Tentukan status: cek checkout dulu, baru checkin
    final String status;
    final Color backgroundColor;
    final Color textColor;

    if (isCheckedOut) {
      // Sudah checkout
      status = 'Keluar';
      backgroundColor = AppColors.redColor.withAlpha(30);
      textColor = AppColors.redColor;
    } else if (isCheckedIn) {
      // Sudah checkin tapi belum checkout
      status = 'Masuk';
      backgroundColor = AppColors.greenColor.withAlpha(30);
      textColor = AppColors.greenColor;
    } else {
      // Belum checkin sama sekali
      status = 'Belum Masuk';
      backgroundColor = AppColors.greyColor.withAlpha(30);
      textColor = AppColors.greyColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: AppTextStyles.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
