import 'package:flutter/material.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/core/theme/app_colors.dart';
import 'package:sun_scan/core/theme/app_text_styles.dart';

class GuestEmptyWidget extends StatelessWidget {
  const GuestEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.svg.svgUsers.svg(
            width: 80,
            height: 80,
            colorFilter: ColorFilter.mode(AppColors.greyColor, BlendMode.srcIn),
          ),
          SizedBox(height: 16),
          Text(
            'Belum ada tamu terdaftar. Silakan tambahkan tamu untuk acara ini.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.greyColor),
          ),
        ],
      ),
    );
  }
}
