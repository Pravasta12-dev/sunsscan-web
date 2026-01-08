import 'package:flutter/material.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/core/theme/app_colors.dart';

import '../../../../../core/theme/app_text_styles.dart';

class GuestErrorWidget extends StatelessWidget {
  const GuestErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.svg.svgError.svg(
            width: 80,
            height: 80,
            colorFilter: const ColorFilter.mode(
              AppColors.whiteColor,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Terjadi kesalahan saat memuat data tamu.',
            style: AppTextStyles.bodyLarge,
          ),
        ],
      ),
    );
  }
}
