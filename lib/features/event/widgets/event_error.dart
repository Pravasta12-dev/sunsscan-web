import 'package:flutter/material.dart';
import 'package:sun_scan/core/helper/assets/assets.gen.dart';
import 'package:sun_scan/core/theme/app_colors.dart';

import 'package:sun_scan/core/theme/app_text_styles.dart';

class EventErrorWidget extends StatelessWidget {
  const EventErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.svg.svgError.svg(
            width: 120,
            height: 120,
            colorFilter: const ColorFilter.mode(
              AppColors.whiteColor,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Terjadi kesalahan saat memuat acara.',
            style: AppTextStyles.bodyLarge,
          ),
        ],
      ),
    );
  }
}
